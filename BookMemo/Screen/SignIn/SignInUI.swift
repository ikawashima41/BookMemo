import UIKit
import RxCocoa

protocol SignInUI: UI {
    var didSignInButtonTapped: ControlEvent<Void> { get }
    var didSignUpButtonTapped: ControlEvent<Void> { get }
    var emailTextFieldText: ControlProperty<String?> { get }
    var passwordTextFieldText: ControlProperty<String?> { get }
    var isSignInButtonHidden: Binder<Bool> { get }
    func setupUI()
}

extension SignInUIImpl {
    var isSignInButtonHidden: Binder<Bool> {
        signupButton.rx.isHidden
    }

    var didSignInButtonTapped: ControlEvent<Void> {
        return SignInButton.rx.tap
    }

    var didSignUpButtonTapped: ControlEvent<Void> {
        return signupButton.rx.tap
    }

    var emailTextFieldText: ControlProperty<String?> {
        return emailTextField.rx.text
    }

    var passwordTextFieldText: ControlProperty<String?> {
        return passwordTextField.rx.text
    }
}

final class SignInUIImpl: SignInUI {
    weak var viewController: UIViewController?

    private let emailLabel = UILabel.Builder()
        .text(with: "メールアドレス")
        .build()

    private let passwordLabel = UILabel.Builder()
        .text(with: "パスワード")
        .build()

    private lazy var emailTextField = UITextField.Builder()
        .placeHolder(with: "テキスト入力")
        .text(with: "test2@gmail.com")
        .delegate(with: viewController)
        .build()

    private lazy var passwordTextField = UITextField.Builder()
        .placeHolder(with: "テキスト入力")
        .text(with: "123123")
        .delegate(with: viewController)
        .build()

    let SignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ログイン", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()

    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("新規作成", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()

    func setupUI() {
        guard let weakSelf = viewController else {
            return
        }

        weakSelf.view.backgroundColor = .white
        weakSelf.title = "ログイン"

        weakSelf.view.add(
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            SignInButton,
            signupButton
        )

        [emailLabel.topAnchor.constraint(equalTo: weakSelf.view.safeAreaLayoutGuide.topAnchor, constant: 40),
         emailLabel.leftAnchor.constraint(equalTo: emailTextField.leftAnchor),
         emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -8),

         emailTextField.leftAnchor.constraint(equalTo: weakSelf.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
         emailTextField.rightAnchor.constraint(equalTo: weakSelf.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
         emailTextField.heightAnchor.constraint(equalToConstant: 40),

         passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
         passwordLabel.leftAnchor.constraint(equalTo: emailTextField.leftAnchor),

         passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
         passwordTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor),
         passwordTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor),
         passwordTextField.heightAnchor.constraint(equalToConstant: 40),

         SignInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50),
         SignInButton.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor),
         SignInButton.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor),
         SignInButton.heightAnchor.constraint(equalToConstant: 50),

         signupButton.topAnchor.constraint(equalTo: SignInButton.bottomAnchor, constant: 30),
         signupButton.rightAnchor.constraint(equalTo: SignInButton.rightAnchor),
         signupButton.heightAnchor.constraint(equalToConstant: 50),
         signupButton.widthAnchor.constraint(equalToConstant: 120)]
            .forEach {
                $0.isActive = true
        }
    }
}
