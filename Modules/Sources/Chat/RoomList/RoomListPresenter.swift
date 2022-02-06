import Foundation
import Core

public final class RoomListPresenter: RoomListPresentation, DependencyInjectable, RoomListInteractorOutput {
    public init() {}
    
    // MARK: - DependencyInjectable

    public struct Dependency {
        public init(view: RoomListView? = nil, useCase: RoomListUseCase, wireframe: RoomListWireframe) {
            self.view = view
            self.useCase = useCase
            self.wireframe = wireframe
        }
        
        public weak var view: RoomListView?
        public let useCase: RoomListUseCase
        public let wireframe: RoomListWireframe
    }
    
    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - RoomListPresentation

    public func didSelectRoom(roomId: Int) {
        dependency.wireframe.presentRoomView(roomId: roomId)
    }
    
    public func didTapCreateRoomButton() {
        dependency.wireframe.presentCreateRoomView()
    }
    
    public func viewDidLoad() {
        dependency.useCase.subscribeRooms()
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
