import Core
import UIKit

public final class ChatRoomListViewController: UIViewController, ChatRoomListView,
    DependencyInjectable, UICollectionViewDelegate
{

    // MARK: - DependencyInjectable

    public struct Dependency {
        public init(presenter: ChatRoomListPresentation) {
            self.presenter = presenter
        }

        public let presenter: ChatRoomListPresentation
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - ChatRoomListView

    public func show(chatRooms: [ChatRoomList.ChatRoom]) {
        self.chatRooms = chatRooms
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(
        _ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: indexPath, animated: true)
        dependency.presenter.didSelectChatRoom(chatRoomId: chatRooms[indexPath.item].id)
    }

    // MARK: - Override

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Room list"
        navigationItem.rightBarButtonItem = .init(
            systemItem: .add,
            primaryAction: .init(handler: { [weak self] _ in
                self?.dependency.presenter.didTapCreateChatRoomButton()
            }),
            menu: nil)

        chatRoomList.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatRoomList.view)
        NSLayoutConstraint.activate([
            chatRoomList.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatRoomList.view.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chatRoomList.view.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chatRoomList.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

        updateChatRoomListView()
        dependency.presenter.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dependency.presenter.viewWillAppear()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dependency.presenter.viewDidAppear()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dependency.presenter.viewWillDisappear()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dependency.presenter.viewDidDisappear()
    }

    deinit {
        dependency.presenter.viewDidDeinit()
    }

    // MARK: - Private

    private var dependency: Dependency!

    private var chatRooms: [ChatRoomList.ChatRoom] = [] {
        didSet { updateChatRoomListView() }
    }

    private lazy var chatRoomList:
        (
            view: UICollectionView,
            dataSource: UICollectionViewDiffableDataSource<Section, ChatRoomList.ChatRoom>
        ) = {
            let config = UICollectionLayoutListConfiguration(appearance: .plain)
            let layout = UICollectionViewCompositionalLayout.list(using: config)
            let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
            view.delegate = self

            let cellRegistration = UICollectionView
                .CellRegistration<UICollectionViewListCell, ChatRoomList.ChatRoom> {
                    cell, indexPath, room in
                    var content = cell.defaultContentConfiguration()
                    content.text = room.name
                    content.textProperties.font = .boldSystemFont(ofSize: 17)
                    content.secondaryText = "\(room.updatedAt) (\(room.userCount) users)"
                    cell.contentConfiguration = content
                    cell.accessories.removeAll()
                    if room.unreadCount > 0 {
                        cell.accessories.append(.label(text: "\((room.unreadCount))"))
                    }
                    cell.accessories.append(.disclosureIndicator())
                }

            let dataSource = UICollectionViewDiffableDataSource<Section, ChatRoomList.ChatRoom>(
                collectionView: view,
                cellProvider: { collectionView, indexPath, item -> UICollectionViewCell? in
                    collectionView.dequeueConfiguredReusableCell(
                        using: cellRegistration, for: indexPath, item: item)
                })

            return (view, dataSource)
        }()

    private enum Section {
        case main
    }

    private func updateChatRoomListView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatRoomList.ChatRoom>()
        snapshot.appendSections([.main])
        snapshot.appendItems(chatRooms, toSection: .main)
        chatRoomList.dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Preview

#if DEBUG
    import SwiftUI
    import ChatUseCase

    struct ChatRoomListViewController_Wrapper: UIViewControllerRepresentable {
        typealias UIViewControllerType = UINavigationController

        func makeUIViewController(context: Context) -> UINavigationController {
            let viewController = ChatRoomListViewController()
            let presenter = ChatRoomListPresenter()
            let router = ChatRoomListRouter()
            let useCases = ChatRoomListUseCases(
                subscribeChatRooms: AnyPublisherUseCase(SubscribeChatRoomsInteractorStub())
            )

            viewController.inject(.init(presenter: presenter))
            presenter.inject(.init(view: viewController, router: router, useCases: useCases))
            router.inject(
                .init(sceneResolver: DummySceneResolver(), viewController: viewController))
            return UINavigationController(rootViewController: viewController)
        }

        func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        }
    }

    struct RoomListViewController_Previews: PreviewProvider {
        static var previews: some View {
            ChatRoomListViewController_Wrapper()
                .previewLayout(.device)
        }
    }
#endif
