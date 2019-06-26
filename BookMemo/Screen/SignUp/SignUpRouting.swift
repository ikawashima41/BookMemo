import UIKit

protocol SignUpRouting: RoutingType {
    func showMainTab()
}

final class SignUpRoutingImpl: SignUpRouting {

    var viewController: UIViewController?

    func showMainTab() {
        let mainTabVC = MainTabBarController()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = mainTabVC
    }
}
