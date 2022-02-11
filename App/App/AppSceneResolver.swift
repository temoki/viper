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
        let viewController = ChatRoomListViewController()
        let presenter = ChatRoomListPresenter()
        let router = ChatRoomListRouter()
        let useCases = ChatRoomListUseCases(
            publishChatRooms: AnyPublisherUseCase(PublishChatRoomsInteractorStub())
        )
        
        viewController.inject(.init(presenter: presenter))
        presenter.inject(.init(view: viewController, router: router, useCases: useCases))
        router.inject(.init(sceneResolver: self, viewController: viewController))
        
        return viewController
    }
}
