import UIKit.UIViewController
import Core

public final class RoomListRouter: RoomListRouterContract, DependencyInjectable {
    public init() {}
    
    // MARK: - DependencyInjectable
    
    public struct Dependency {
        public init(sceneResolver: SceneResolver, viewController: UIViewController) {
            self.sceneResolver = sceneResolver
            self.viewController = viewController
        }
        
        public let sceneResolver: SceneResolver
        public weak var viewController: UIViewController?
    }
    
    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - RoomListWireframe
    
    public func presentRoomView(roomId: Int) {
        let viewController = dependency.sceneResolver.resolve(.chatRoom(roomId: roomId))
        dependency.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func presentRoomCreateView() {
        let viewController = dependency.sceneResolver.resolve(.chatRoomCreate)
        let navigationController = UINavigationController(rootViewController: viewController)
        dependency.viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
