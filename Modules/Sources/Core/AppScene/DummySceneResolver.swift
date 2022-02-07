import UIKit.UIViewController

public struct DummySceneResolver: SceneResolver {
    public init() {}
    
    public func resolve(_ scene: Scene) -> UIViewController {
        DummyViewController(title: scene.name)
    }
}

public final class DummyViewController: UIViewController {
    public convenience init(title: String) {
        self.init()
        self.title = title
        view.backgroundColor = .systemBackground
    }
}
