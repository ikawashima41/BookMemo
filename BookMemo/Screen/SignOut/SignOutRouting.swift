import UIKit

protocol SignOutRouting: RoutingType {
    func showSignIn()
}

final class SignOutRoutingImpl: SignOutRouting {

    weak var viewController: UIViewController?

    func showSignIn() {
        let vc = AppFactory.makeSignInViewController()
        viewController?.present(vc, animated: true)
    }
}
