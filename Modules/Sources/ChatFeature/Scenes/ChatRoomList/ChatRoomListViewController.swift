import Core
import SwiftUI
import UIKit

public final class ChatRoomListViewController: UIViewController, ChatRoomListView,
    DependencyInjectable
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
        self.state.chatRooms = chatRooms
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

        hostringController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostringController.view)
        NSLayoutConstraint.activate([
            hostringController.view.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostringController.view.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostringController.view.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hostringController.view.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])

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

    private let state = ChatRoomListViewSwiftUIState()

    private lazy var hostringController = UIHostingController(
        rootView: ChatRoomListViewSwiftUIView(state: state, presentation: dependency.presenter)
    )
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
