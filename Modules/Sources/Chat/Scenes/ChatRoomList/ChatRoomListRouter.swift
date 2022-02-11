import UIKit.UIViewController
import Core

public final class ChatRoomListRouter: ChatRoomListWireframe, DependencyInjectable {
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
    
    // MARK: - ChatRoomListWireframe
    
    public func presentChatRoomView(chatRoomId: Int) {
        let viewController = dependency.sceneResolver.resolve(.chatRoom(roomId: chatRoomId))
        dependency.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func presentChatRoomCreateView() {
        let viewController = dependency.sceneResolver.resolve(.chatRoomCreate)
        let navigationController = UINavigationController(rootViewController: viewController)
        dependency.viewController?.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
}
