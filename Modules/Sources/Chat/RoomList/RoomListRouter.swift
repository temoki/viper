import UIKit.UIViewController
import Core

public final class RoomListRouter: RoomListWireframe, DependencyInjectable {
    public init() {}
    
    // MARK: - DependencyInjectable
    
    public struct Dependency {
        public init(viewAssembler: ViewAssembler, viewController: UIViewController) {
            self.viewAssembler = viewAssembler
            self.viewController = viewController
        }
        
        public let viewAssembler: ViewAssembler
        public weak var viewController: UIViewController?
    }
    
    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - RoomListWireframe
    
    public func presentRoomView(roomId: Int) {
        let viewController = dependency.viewAssembler.assembleChatView(.room(roomId: roomId))
        dependency.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func presentCreateRoomView() {
        let viewController = dependency.viewAssembler.assembleChatView(.createRoom)
        let navigationController = UINavigationController(rootViewController: viewController)
        dependency.viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
