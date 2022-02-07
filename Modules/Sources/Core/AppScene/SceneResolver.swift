import UIKit.UIViewController

public protocol SceneResolver {
    func resolve(_ scene: Scene) -> UIViewController
}
