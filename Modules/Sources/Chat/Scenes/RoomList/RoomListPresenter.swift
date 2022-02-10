import Combine
import Core
import Foundation
import UseCase

public final class RoomListPresenter: RoomListPresenterContract, DependencyInjectable {
    public init() {}
    
    // MARK: - DependencyInjectable

    public struct UseCases {
        public let publishChatRoomsUseCase: PublishChatRoomsUseCase
    }

    public struct Dependency {
        public init(
            view: RoomListViewContract?,
            router: RoomListRouterContract,
            useCases: RoomListUseCases
        ) {
            self.view = view
            self.router = router
            self.useCases = useCases
        }
        
        public weak var view: RoomListViewContract?
        public let router: RoomListRouterContract
        public let useCases: RoomListUseCases
    }
    
    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - RoomListPresentation

    public func didSelectRoom(roomId: Int) {
        dependency.router.presentRoomView(roomId: roomId)
    }
    
    public func didTapCreateRoomButton() {
        dependency.router.presentRoomCreateView()
    }
    
    public func viewDidLoad() {
        dependency.useCases.publishRooms.invoke(())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] output in
                self?.dependency.view?.show(rooms: output.rooms)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
    private var cancellables = Set<AnyCancellable>()
}
