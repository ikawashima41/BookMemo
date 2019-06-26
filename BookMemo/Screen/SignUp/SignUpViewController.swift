import UIKit
import APIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    private var viewModel: SignUpViewModel

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "メールアドレス"
        return label
    }()

    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "パスワード"
        return label
    }()

    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "パスワード確認"
        return label
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "テキスト入力"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "テキスト入力"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "テキスト入力"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "保存", style: .plain, target: self, action: nil)
        button.isEnabled = false
        button.tintColor = UIColor(white: 0, alpha: 0)
        return button
    }()

    private lazy var cancelButton: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: #selector(didCancelButtonTapped))
        return cancelButton
    }()

    @objc private func didCancelButtonTapped() {
        dismiss(animated: true)
    }

    //==================================================
    // MARK: - Routing
    //==================================================

    private lazy var routing: SignUpRouting = {
        let routing = SignUpRoutingImpl()
        routing.viewController = self
        return routing
    }()

    //==================================================
    // MARK: - Rx
    //==================================================

    private let disposeBag: DisposeBag = .init()

    //==================================================
    // MARK: - UIViewController override
    //==================================================

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupObserver()
        bindUI()
    }
}

extension SignUpViewController {
    private func setupUI() {
        navigationItem.title = "新規登録"
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton

        [emailLabel, passwordLabel, confirmPasswordLabel, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [emailLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
         emailLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),

         emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
         emailTextField.leftAnchor.constraint(equalTo: emailLabel.leftAnchor),
         emailTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
         emailTextField.heightAnchor.constraint(equalToConstant: 40),

         passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
         passwordLabel.leftAnchor.constraint(equalTo: emailTextField.leftAnchor),

         passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
         passwordTextField.leftAnchor.constraint(equalTo: passwordLabel.leftAnchor),
         passwordTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor),
         passwordTextField.heightAnchor.constraint(equalToConstant: 40),

         confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
         confirmPasswordLabel.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor),

         confirmPasswordTextField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 8),
         confirmPasswordTextField.leftAnchor.constraint(equalTo: confirmPasswordLabel.leftAnchor),
         confirmPasswordTextField.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor),
         confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            ]
            .forEach {
                $0.isActive = true
        }
    }

    private func bindUI() {
        let input = SignUpViewModel.Input(didSaveButtonTapped: saveButton.rx.tap.asObservable(), emailText: emailTextField.rx.text.orEmpty.asObservable(), passwordText: passwordTextField.rx.text.orEmpty.asObservable(), confirmText: confirmPasswordTextField.rx.text.orEmpty.asObservable())

        let output = viewModel.transform(input: input)
        output.isValid.subscribe(onNext: { [weak self] bool in
            self?.saveButton.isEnabled = bool
            let systemBlueColor = UIColor(red: 0, green: 122 / 255, blue: 1, alpha: 1)
            self?.saveButton.tintColor = bool ? systemBlueColor : UIColor(white: 0, alpha: 0)
        }).disposed(by: disposeBag)

        output.result.subscribe(onNext: { [weak self] _ in
            self?.routing.showMainTab()
        }).disposed(by: disposeBag)

        output.error.subscribe(onNext: { [weak self] error in
            self?.createAlert(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
