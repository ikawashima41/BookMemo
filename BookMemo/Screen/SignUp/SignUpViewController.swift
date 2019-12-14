import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {

    private lazy var ui: SignUpUI = {
        let ui = SignUpUIImpl()
        ui.viewController = self
        return ui
    }()

    private var viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var routing: SignUpRouting = {
        let routing = SignUpRoutingImpl()
        routing.viewController = self
        return routing
    }()

    private let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        ui.setupUI()
        setupObserver()
        bindUI()
    }
}

extension SignUpViewController {

    private func bindUI() {
        let input = SignUpViewModel.Input(
            didSaveButtonTapped: ui.didSaveButtonTapped.asObservable(),
            emailText: ui.emailTextFieldText.orEmpty.asObservable(),
            passwordText: ui.passwordTextFieldText.orEmpty.asObservable(),
            confirmText: ui.confirmedPasswordText.orEmpty.asObservable()
        )

        let output = viewModel.transform(input: input)

        output.result.subscribe(onNext: { [weak self] _ in
            self?.routing.showMainTab()
        }).disposed(by: disposeBag)

        output.error.subscribe(onNext: { [weak self] error in
            self?.createAlert(message: error.localizedDescription)
        }).disposed(by: disposeBag)

        ui.didCancelButtonTapped.subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
}
