import UIKit
import DataManager

protocol SplashRouting: RoutingType {
    func showSignIn()
    func showTutorial()
}

final class SplashRoutingImpl: SplashRouting {

    weak var viewController: UIViewController?

    func showSignIn() {
        let vc = AppFactory.makeSignInViewController()
        viewController?.present(vc, animated: true)
    }

    func showTutorial() {
        let vc = TutorialViewController()
        viewController?.present(vc, animated: true)
    }
}
