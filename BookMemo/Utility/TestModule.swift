
import Foundation
import UIKit
import RxRelay
import RxSwift

// =======================
// Output-object Injection
// =======================

// 1.出力を切り出す
protocol ValidatorHandlerProtocol {
    func success()
    func failed()
}

class NumberValidator {
    func validate(inputText: String, output: ValidatorHandlerProtocol) {
        if Int(inputText) != nil {
            output.success()
        }
        else {
            output.failed()
        }
    }

    func success() {}

    func failed() {}
}

// 2. spyを作成(出力内容を記録する)

class ValidatorHandlerSpy: ValidatorHandlerProtocol {
    enum CallArgs {
        case success
        case failed
    }

    // メソッド呼び出し→ここに記録されていく
    private(set) var callArgs: [CallArgs] = []

    func success() {
        self.callArgs.append(.success)
    }

    func failed() {
        self.callArgs.append(.failed)
    }
}

// 補足：ライフサイクルを記録するspy
class SpyViewController: UIViewController {
    enum CallArgs {
        case viewDidDisappear(_ animated: Bool)
        case viewDidAppear(_ animated: Bool)
    }

    fileprivate(set) var callArgs: [CallArgs] = []

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.callArgs.append(.viewDidDisappear(animated))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.callArgs.append(.viewDidAppear(animated))
    }
}

// ====================
// InputObjectInjection
// ====================

class UserNameUpperCasedAPI {

    // 2. プロトコルを渡せるようにしておく　内部的に使うAPIクラスを渡せるようにするため
    func getUserName(apiManger: APIManagerProtocol, callback: @escaping (String) -> Void) {
        // 3. protocolのメソッドに変更
        apiManger.get(path: "/username") { userName in
            callback(userName.uppercased())
        }
    }
}

class APIManager {
    static let shared = APIManager()

    func get(path: String, callback: @escaping (String) -> Void ) {
        callback("Test")
    }
}

// 1. プロトコル作成
protocol APIManagerProtocol {
    func get(path: String, callback: @escaping (String) -> Void )
}

// スタブを作成（テスト用の値を渡す）
class APIManagerStub: APIManagerProtocol {

    var returnedValue: String

    // 事前にテストに渡したい値を事前に指定する。
    init(returnedValue: String) {
        self.returnedValue = returnedValue
    }

    func get(path: String, callback: @escaping (String) -> Void) {
        callback(returnedValue)
    }
}

// ===================
// SingleMethodStubSpy
// ===================
class NextViewController: UIViewController {

}

class MyViewController: UIViewController {

    private let navigator: Navigatorprotocol

    init(navigatingBy navigator: Navigatorprotocol) {
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didButtonTap(_ sender: Any) {
        self.navigator.push(viewController: NextViewController(), animated: true)
    }
}

// 1.　プロトコル作成
protocol Navigatorprotocol {
    func push(
        viewController: UIViewController,
        animated: Bool
    )
}

// 2. pushViewcontrollerを呼ぶオブジェクト作成

class Navigator: Navigatorprotocol {
    private let navigationController: UINavigationController

    init(willPushTo navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func push(viewController: UIViewController, animated: Bool) {
        self.navigationController.pushViewController(viewController, animated: animated)
    }
}

class NavigatorSpy: Navigatorprotocol {
    typealias CallArgs = (
        viewController: UIViewController,
        animated: Bool
    )

    private(set) var callArgs: [CallArgs] = []

    func push(viewController: UIViewController, animated: Bool) {
        self.callArgs.append((viewController: viewController, animated: animated))
    }
}

// ===================
// DependencyBag
// ===================

// ※ initの際に注入するプロトコルが多いと大変

protocol Loggerprotocol {
    func log(_: String)
}

protocol APIClientProtocol {}

protocol ServiceProtocol {}

// 注入するp路とコルをbagにまとめる
struct ViewControllerBag {
    let api: APIClientProtocol
    let logger: Loggerprotocol
    let service: ServiceProtocol
}

// ファクトリ関数は生やす
extension ViewControllerBag {
    static func create(
        api: APIClientProtocol = APIClientStub(),
        logger: Loggerprotocol = LoggerStub(),
        service: ServiceProtocol = ServiceStub()
    ) -> ViewControllerBag {
        return ViewControllerBag(api: api, logger: logger, service: service)
    }
}

// stubを作る
class APIClientStub: APIClientProtocol {

}
class LoggerStub: Loggerprotocol {
    func log(_: String) {

    }
}
class ServiceStub: ServiceProtocol {

}

class ViewControllerA: UIViewController {
    private let bag: ViewControllerBag
    private let navigator: Navigatorprotocol

    init(
        using bag: ViewControllerBag,
        navigatingBy navigator: Navigatorprotocol
    ) {
        self.bag = bag
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func doSomething() {

    }
}

// ===================
// Logging observer
// ===================

// 1. モデルからloggingの責務を外す
class ExampleModel {

    private let stateVariable = BehaviorRelay<Bool>(value: false)

    var didChange: Observable<Bool> {
        return self.stateVariable.asObservable()
    }

    var currentState: Bool {
        get { return self.stateVariable.value }
        set { self.stateVariable.accept(newValue) }
    }

    func doSomething() {
        self.currentState = true
    }
}

// modelを監視する複数のLogger を作成する
class ExampleModelLogger {
    private let disposeBag: DisposeBag = .init()

    init(model: ExampleModel, logger: Loggerprotocol) {
        model.didChange
            .subscribe(onNext: { state in
                logger.log("State was changed")
            }).disposed(by: disposeBag)
    }
}

// ===================
// RxEventBlocker
// ===================

class RequestModel {
    private var isFetching = false

    let resultDidChange = BehaviorSubject<String?>(value: nil)

    let errorDidChange = BehaviorSubject<Error?>(value: nil)

    func fetch() {
        if self.isFetching { return }
        self.isFetching = true

        DispatchQueue.main.async {
            self.isFetching = false

            let context = "Fetched!"
            self.resultDidChange.onNext(context)
        }
    }

}

// ===================
// StateMachineModel
// ===================

enum State {
    case notFetchedYet
    case fetching
    case fetched(String)
    case failed(Error)
}

class RequestModelState {

    // 単一のフィールドで状態を保持する
    let stateVariable = BehaviorRelay<State>(value: .notFetchedYet)

    // stateVariableの変化がはフィールドを通して外部から監視できる
    var didChange: Observable<State> {
        return self.stateVariable.asObservable()
    }

    var currentState: State {
        get { return self.stateVariable.value }
        set { self.stateVariable.accept(newValue) }
    }

    func fetch() {
        switch self.currentState {
        case .fetching:
            return
        case .notFetchedYet, .fetched, .failed:
            self.currentState = .fetching

            DispatchQueue.main.async {
                let context = "Fetched!"
                self.currentState = .fetched(context)
            }
        }
    }
}

// ===================
// Preprocessor Token
// ===================

// 型検査でテストを減らすパターン
class MyCell: UITableViewCell {
    private static let reuseidentifier = "myTableViewCell"

    static func register(to tableView: UITableView) -> RegistrationToken {
        tableView.register(self, forCellReuseIdentifier: self.reuseidentifier)
        return RegistrationToken()
    }

    static func dequeue(from tableView: UITableView, musthave token: RegistrationToken) -> MyCell {
        return tableView.dequeueReusableCell(withIdentifier: self.reuseidentifier) as! MyCell
    }

    struct RegistrationToken {
        fileprivate init() {}
    }
}
