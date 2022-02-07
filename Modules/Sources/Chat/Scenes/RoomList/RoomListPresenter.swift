import Foundation
import Core

public final class RoomListPresenter: RoomListPresenterContract, DependencyInjectable, RoomListInteractorOutputContract {
    public init() {}
    
    // MARK: - DependencyInjectable

    public struct Dependency {
        public init(view: RoomListViewContract? = nil, interactor: RoomListInteractorContract, router: RoomListRouterContract) {
            self.view = view
            self.interactor = interactor
            self.router = router
        }
        
        public weak var view: RoomListViewContract?
        public let interactor: RoomListInteractorContract
        public let router: RoomListRouterContract
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
        dependency.interactor.subscribeRooms()
    }
    
    // MARK: - RoomListInteractorOutput
    
    public func output(rooms: [RoomList.Room]) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.view?.show(rooms: rooms)
        }
    }
    
    public func output(error: RoomList.Error) {
        DispatchQueue.main.async { [weak self] in
            self?.dependency.view?.show(error: error.localizedDescription)
        }
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
