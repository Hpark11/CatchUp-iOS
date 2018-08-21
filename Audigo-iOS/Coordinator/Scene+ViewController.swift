import Foundation
import UIKit

extension SceneType where Self: InstantiatableFromNIB {
    func viewController() -> UIViewController  {
        return self.instantiateFromNIB()
    }
}

extension SceneType where Self: InstantiatableFromStoryboard {
    func viewController() -> UIViewController {
        return self.instantiateFromStoryboard()
    }
}
