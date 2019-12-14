import RxSwift
import DataManager

final class SignUpViewModel {

    private let dependency: AccountDataStore

    init(dependency: AccountDataStore) {
        self.dependency = dependency
    }
}

extension SignUpViewModel: ViewModelType {

    struct Input {
        var didSaveButtonTapped: Observable<Void>
        var emailText: Observable<String>
        var passwordText: Observable<String>
        var confirmText: Observable<String>
    }

    struct OutPut {
        var result: Observable<SignUpAPI.Response>
        var error: Observable<Error>
        var isValid: Observable<Bool>
    }

    func transform(input: Input) -> OutPut {
        let emailTextRelay = input.emailText.map {
            $0.count >= 6
        }

        let passwordTextRelay = input.passwordText.map {
            $0.count >= 6
        }

        let confirmTextRelay = input.confirmText.map {
            $0.count >= 6
        }

        let isValid = Observable.combineLatest(
            emailTextRelay,
            passwordTextRelay,
            confirmTextRelay
        ) {
            $0 && $1 && $2
        }

        let parameter = Observable.combineLatest(input.emailText, input.passwordText)

        let response = input.didSaveButtonTapped
            .withLatestFrom(parameter)
            .flatMap { (email, password) -> Observable<Event<SignUpAPI.Response>> in
                let info = AuthModel(
                    email: email,
                    password: password
                )
                return self.dependency.signUp(with: info)
                .materialize()
        }.share(replay: 1)

        return OutPut(
            result: response.elements(),
            error: response.errors(),
            isValid: isValid
        )
    }
}
