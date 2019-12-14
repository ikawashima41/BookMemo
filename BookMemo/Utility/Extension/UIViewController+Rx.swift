import UIKit
import RxCocoa
import RxSwift
import RxRelay

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        return sentMessage(#selector(base.viewWillAppear(_:)))
            .map { _ in () }
            .share(replay: 1)
    }

    var viewDidAppear: Observable<Void> {
        return sentMessage(#selector(base.viewDidAppear(_:)))
            .map { _ in () }
            .share(replay: 1)
    }

    var viewWillDisappear: Observable<Void> {
        return sentMessage(#selector(base.viewWillDisappear(_:)))
            .map { _ in () }
            .share(replay: 1)
    }

    var viewDidDisappear: Observable<Void> {
        return sentMessage(#selector(base.viewDidDisappear(_:)))
            .map { _ in () }
            .share(replay: 1)
    }
}
