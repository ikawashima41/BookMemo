import UIKit

protocol BookDetailRouting: RoutingType {
    func showHomeVC()
}

final class BookDetailRoutingImpl: BookDetailRouting {
    var viewController: UIViewController?

    func showHomeVC() {
        guard let view = viewController?.navigationController else { return }
        view.popViewController(animated: true)
    }
}
