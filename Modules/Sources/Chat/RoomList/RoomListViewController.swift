import UIKit
import Core

public final class RoomListViewController: UIViewController, RoomListView, DependencyInjectable, UICollectionViewDelegate {
    
    // MARK: - DependencyInjectable

    public struct Dependency {
        public init(presentation: RoomListPresentation) {
            self.presentation = presentation
        }
        
        public let presentation: RoomListPresentation
    }
    
    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - RoomListView
    
    public func show(rooms: [RoomList.Room]) {
        self.rooms = rooms
    }
    
    public func show(error message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        dependency.presentation.didSelectRoom(roomId: rooms[indexPath.item].id)
    }
    
    // MARK: - Override
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Room list"
        navigationItem.rightBarButtonItem = .init(
            systemItem: .add,
            primaryAction: .init(handler: { [weak self] _ in
                self?.dependency.presentation.didTapCreateRoomButton()
            }),
            menu: nil)

        roomList.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roomList.view)
        NSLayoutConstraint.activate([
            roomList.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            roomList.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            roomList.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            roomList.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        updateRoomListView()
        dependency.presentation.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.presentation.viewWillAppear()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dependency.presentation.viewDidAppear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dependency.presentation.viewWillDisappear()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dependency.presentation.viewDidDisappear()
    }
    
    deinit {
        dependency.presentation.viewDidDeinit()
    }
    
    // MARK: - Private

    private var dependency: Dependency!
    
    private var rooms: [RoomList.Room] = [] {
        didSet { updateRoomListView() }
    }
    
    private lazy var roomList: (
        view: UICollectionView,
        dataSource: UICollectionViewDiffableDataSource<Section, RoomList.Room>
    ) = {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        
        let cellRegistration = UICollectionView
            .CellRegistration<UICollectionViewListCell, RoomList.Room> { cell, indexPath, room in
                var content = cell.defaultContentConfiguration()
                content.text = room.name
                content.textProperties.font = .boldSystemFont(ofSize: 17)
                content.secondaryText = "(\(room.userCount) users)"
                cell.contentConfiguration = content
                cell.accessories.removeAll()
                if room.unreadCount > 0 {
                    cell.accessories.append(.label(text: "\((room.unreadCount))"))
                }
                cell.accessories.append(.disclosureIndicator())
            }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, RoomList.Room>(
            collectionView: view,
            cellProvider: { collectionView, indexPath, item -> UICollectionViewCell? in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            })
        
        return (view, dataSource)
    }()
    
    private enum Section {
        case main
    }
    
    private func updateRoomListView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RoomList.Room>()
        snapshot.appendSections([.main])
        snapshot.appendItems(rooms, toSection: .main)
        roomList.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct RoomListViewController_Wrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = RoomListViewController()
        let presenter = RoomListPresenter()
        let router = RoomListRouter()
        let interactor = RoomListInteractor()
        
        viewController.inject(.init(presentation: presenter))
        presenter.inject(.init(view: viewController, useCase: interactor, wireframe: router))
        interactor.inject(.init(output: presenter))
        router.inject(.init(viewAssembler: DummyViewAssembler(), viewController: viewController))
        return UINavigationController(rootViewController: viewController)
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}

struct RoomListViewController_Previews: PreviewProvider {
    static var previews: some View {
        RoomListViewController_Wrapper()
            .previewLayout(.device)
    }
}
#endif
