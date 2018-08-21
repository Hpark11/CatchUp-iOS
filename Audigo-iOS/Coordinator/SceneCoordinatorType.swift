import Foundation
import UIKit
import RxSwift

protocol SceneCoordinatorType {
    init(window: UIWindow)
    
    var currentViewController: UIViewController? { get }
    
    @discardableResult
    func transition(to scene: Navigationable, type: SceneTransitionType) -> Observable<Void>
}
