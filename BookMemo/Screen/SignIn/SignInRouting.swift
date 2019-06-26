import UIKit

protocol SignInRouting: RoutingType {
    func showMainTab()
    func showSignUp()
}

final class SignInRoutingImpl: SignInRouting {

    weak var viewController: UIViewController?

    func showMainTab() {
        let mainTabVC = MainTabBarController()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = mainTabVC
    }

    func showSignUp() {
        let vc = AppFactory.makeSignUpViewController()
        viewController?.present(vc, animated: true)
    }
}
