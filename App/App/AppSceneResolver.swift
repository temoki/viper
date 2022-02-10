import Chat
import Core
import UIKit
import UseCase

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
        let useCases = RoomListUseCases(
            publishRooms: AnyPublisherUseCase(PublishChatRoomsUseCaseImpl())
        )
        
        viewController.inject(.init(presenter: presenter))
        presenter.inject(.init(view: viewController, router: router, useCases: useCases))
        router.inject(.init(sceneResolver: self, viewController: viewController))
        
        return viewController
    }
}
