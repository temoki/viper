import Core
import Chat
import UIKit

public final class AppSceneResolver: SceneResolver {
    
    public func resolve(_ scene: Scene) -> UIViewController {
        switch scene {
        case .chatRoomList:
            return assembleChatRoomListScene()

        default:
            assertionFailure("Not yet implemented.")
            return DummySceneResolver().resolve(scene)
        }
    }
}

extension AppSceneResolver {
    func assembleChatRoomListScene() -> UIViewController {
        let viewController = RoomListViewController()
        let presenter = RoomListPresenter()
        let router = RoomListRouter()
        let interactor = RoomListInteractor()
        
        viewController.inject(.init(presenter: presenter))
        presenter.inject(.init(view: viewController, interactor: interactor, router: router))
        interactor.inject(.init(output: presenter))
        router.inject(.init(sceneResolver: self, viewController: viewController))
        
        return viewController
    }
}
