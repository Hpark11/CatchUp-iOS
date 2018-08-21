import Foundation
import UIKit.UIViewController

enum SceneTransitionType {
    enum PopType {
        case root
        case parent
        case vc(viewController: UIViewController)
    }
    
    case root
    case push(animated: Bool)
    case modal(animated: Bool)
    case pop(animated: Bool, level: PopType)
}
