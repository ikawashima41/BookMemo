
import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let HomeBar = AppFactory.makeHomeViewController()
        let SignOutBar = AppFactory.makeSignOutViewController()
        setViewControllers([HomeBar, SignOutBar], animated: false)
    }
}
