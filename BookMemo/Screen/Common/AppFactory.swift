import UIKit
import DataManager

struct AppFactory {
    static func makeSignInViewController() -> UINavigationController {
        let dependency = AccountDataStoreFactory.make()
        let viewModel = SignInViewModel(dependency: dependency)
        let vc = SignInViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: vc)
    }

    static func makeSignUpViewController() -> UINavigationController {
        let dependency = AccountDataStoreFactory.make()
        let viewModel = SignUpViewModel(dependency: dependency)
        let vc = SignUpViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: vc)
    }

    static func makeHomeViewController() -> UINavigationController {
        let dependency = BookDataStoreFactory.make()
        let viewModel = HomeViewModel(dependency: dependency)
        let vc = HomeViewController(viewModel: viewModel)
        vc.tabBarItem = UITabBarItem(title: "一覧", image: #imageLiteral(resourceName: "bookIconTab"), tag: 1)
        let HomeBar = UINavigationController(rootViewController: vc)
        return HomeBar
    }

    static func makeSignOutViewController() -> UINavigationController {
        let dependency = AccountDataStoreFactory.make()
        let viewModel = SignOutViewModel(dependency: dependency)
        let vc = SignOutViewController(viewModel: viewModel)
        vc.tabBarItem = UITabBarItem(title: "設定", image: #imageLiteral(resourceName: "settingIconTab"), tag: 2)
        let SignOutBar = UINavigationController(rootViewController: vc)
        return SignOutBar
    }

    static func makeBookRegistrationViewController() -> UINavigationController {
        let dependency = BookDataStoreFactory.make()
        let viewModel = BookRegistrationViewModel(dependency: dependency)
        let vc = BookRegistrationViewController(viewModel: viewModel)
        return UINavigationController(rootViewController: vc)
    }


    static func makeBookDetailViewController(book: BookInfomation) -> BookDetailViewController {
        let dependency = BookDataStoreFactory.make()
        let viewModel = BookDetailViewModel(dependency: dependency)
        return BookDetailViewController(viewModel: viewModel, book: book)
    }
}
