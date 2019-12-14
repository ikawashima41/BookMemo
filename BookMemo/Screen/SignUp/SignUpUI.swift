import UIKit
import RxCocoa

protocol SignUpUI: UI {
    var didSaveButtonTapped: ControlEvent<Void> { get }
    var didCancelButtonTapped: ControlEvent<Void> { get }
    var emailTextFieldText: ControlProperty<String?> { get }
    var passwordTextFieldText: ControlProperty<String?> { get }
    var confirmedPasswordText: ControlProperty<String?>  { get }
    func setupUI()
}

extension SignUpUIImpl {

    var didSaveButtonTapped: ControlEvent<Void> {
        return saveButton.rx.tap
    }

    var didCancelButtonTapped: ControlEvent<Void> {
        return cancelButton.rx.tap
    }

    var emailTextFieldText: ControlProperty<String?> {
        return emailTextField.rx.text
    }

    var passwordTextFieldText: ControlProperty<String?> {
        return passwordTextField.rx.text
    }

    var confirmedPasswordText: ControlProperty<String?> {
        return confirmedPasswordTextField.rx.text
    }
}

final class SignUpUIImpl: SignUpUI {
    weak var viewController: UIViewController?

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

    private lazy var confirmedPasswordLabel: UILabel = {
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

    private lazy var confirmedPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = viewController
        textField.placeholder = "テキスト入力"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "保存", style: .plain, target: self, action: nil)
        button.tintColor = UIColor(white: 0, alpha: 0)
        return button
    }()

    private lazy var cancelButton: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(title: "閉じる", style: .plain, target: self, action: nil)
        return cancelButton
    }()


    func setupUI() {
        guard let weakSelf = viewController else {
            return
        }
        
        weakSelf.navigationItem.title = "新規登録"
        weakSelf.navigationItem.leftBarButtonItem = cancelButton
        weakSelf.navigationItem.rightBarButtonItem = saveButton

        weakSelf.view.add(
            emailLabel,
            passwordLabel,
            confirmedPasswordLabel,
            emailTextField,
            passwordTextField,
            confirmedPasswordTextField
        )

        [emailLabel.topAnchor.constraint(equalTo: weakSelf.view.safeAreaLayoutGuide.topAnchor, constant: 40),
         emailLabel.leftAnchor.constraint(equalTo: weakSelf.view.safeAreaLayoutGuide.leftAnchor, constant: 16),

         emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
         emailTextField.leftAnchor.constraint(equalTo: emailLabel.leftAnchor),
         emailTextField.rightAnchor.constraint(equalTo: weakSelf.view.safeAreaLayoutGuide.rightAnchor, constant: -16),
         emailTextField.heightAnchor.constraint(equalToConstant: 40),

         passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
         passwordLabel.leftAnchor.constraint(equalTo: emailTextField.leftAnchor),

         passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
         passwordTextField.leftAnchor.constraint(equalTo: passwordLabel.leftAnchor),
         passwordTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor),
         passwordTextField.heightAnchor.constraint(equalToConstant: 40),

         confirmedPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
         confirmedPasswordLabel.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor),

         confirmedPasswordTextField.topAnchor.constraint(equalTo: confirmedPasswordLabel.bottomAnchor, constant: 8),
         confirmedPasswordTextField.leftAnchor.constraint(equalTo: confirmedPasswordLabel.leftAnchor),
         confirmedPasswordTextField.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor),
         confirmedPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            ]
            .forEach {
                $0.isActive = true
        }
    }
}

