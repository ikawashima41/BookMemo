import UIKit
import RxSwift

final class SignInViewController: UIViewController {

    private lazy var ui: SignInUI = {
        let ui = SignInUIImpl()
        ui.viewController = self
        return ui
    }()

    private lazy var routing: SignInRouting = {
        let routing = SignInRoutingImpl()
        routing.viewController = self
        return routing
    }()

    private var viewModel: SignInViewModel

    private let disposeBag: DisposeBag = .init()

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ui.setupUI()
        bindUI()
    }
}

private extension SignInViewController {

    private func bindUI() {
        let input = SignInViewModel.Input(
            didSignInButtonTapped: ui.didSignInButtonTapped.asObservable(),
            didSignupButtonTapped: ui.didSignUpButtonTapped.asObservable(),
            emailText: ui.emailTextFieldText.orEmpty.asObservable(),
            passwordText: ui.passwordTextFieldText.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)

//        output.isValid
//            .bind(to: ui.isSignInButtonHidden)
//            .disposed(by: disposeBag)

        output.result.subscribe(onNext: { [weak self] _ in
            self?.routing.showMainTab()
        }).disposed(by: disposeBag)

        output.error.subscribe(onNext: { [weak self] error in
            self?.createAlert(message: error.localizedDescription)
        }).disposed(by: disposeBag)

        ui.didSignUpButtonTapped.subscribe(onNext: { [unowned self] _ in
            self.routing.showSignUp()
        }).disposed(by: disposeBag)
    }
}
