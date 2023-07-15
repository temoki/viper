import UIKit.UIViewController

@MainActor
public protocol SceneResolver {
    func resolve(_ scene: Scene) -> UIViewController
}
