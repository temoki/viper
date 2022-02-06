import UIKit

public struct DummyViewAssembler: ViewAssembler {
    public init() {}

    public func assembleChatView(_ scene: ChatScene) -> UIViewController {
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
