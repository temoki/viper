import ChatUseCase
import Combine
import Core
import Foundation

public final class ChatRoomListPresenter: ChatRoomListPresentation, DependencyInjectable {
    public init() {}

    // MARK: - DependencyInjectable

    public struct UseCases {
        public let publishChatRoomsUseCase: SubscribeChatRoomsUseCase
    }

    public struct Dependency {
        public init(
            view: ChatRoomListView?,
            router: ChatRoomListWireframe,
            useCases: ChatRoomListUseCases
        ) {
            self.view = view
            self.router = router
            self.useCases = useCases
        }

        public weak var view: ChatRoomListView?
        public let router: ChatRoomListWireframe
        public let useCases: ChatRoomListUseCases
    }

    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }

    // MARK: - ChatRoomListPresentation

    public func didSelectChatRoom(chatRoomId: Int) {
        dependency.router.presentChatRoomView(chatRoomId: chatRoomId)
    }

    public func didTapCreateChatRoomButton() {
        dependency.router.presentChatRoomCreateView()
    }

    public func viewDidLoad() {
        dependency.useCases.subscribeChatRooms.invoke(())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] output in
                self?.dependency.view?.show(chatRooms: output.chatRooms)
            })
            .store(in: &cancellables)
    }

    // MARK: - Private

    private var dependency: Dependency!
    private var cancellables = Set<AnyCancellable>()
}
