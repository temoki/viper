import Core
import Chat
import UIKit

final class AppViewAssembler: ViewAssembler {
    func assembleChatView(_ scene: ChatScene) -> UIViewController {
        switch scene {
        case .roomList:
            let viewController = RoomListViewController()
            let presenter = RoomListPresenter()
            let router = RoomListRouter()
            let interactor = RoomListInteractor()
            
            viewController.inject(.init(presentation: presenter))
            presenter.inject(.init(view: viewController, useCase: interactor, wireframe: router))
            interactor.inject(.init(output: presenter))
            router.inject(.init(viewAssembler: self, viewController: viewController))
            
            return viewController

        default:
            return DummyViewController(title: scene.name)
        }
    }
}
