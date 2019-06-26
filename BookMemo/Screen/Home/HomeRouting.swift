import UIKit

protocol HomeRouting: RoutingType {
    func showBookRegistrationVC()
    func showBookDetailVC(book: BookInfomation)
}

final class HomeRoutingImpl: HomeRouting {

    var viewController: UIViewController?

    func showBookRegistrationVC() {
        let vc = AppFactory.makeBookRegistrationViewController()
        viewController?.present(vc, animated: true)
    }

    func showBookDetailVC(book: BookInfomation) {
        let vc = AppFactory.makeBookDetailViewController(book: book)
        guard let view = viewController?.navigationController else { return }
        view.pushViewController(vc, animated: true)
    }
}

