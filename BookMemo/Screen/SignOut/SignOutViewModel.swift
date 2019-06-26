
import RxCocoa
import RxSwift
import DataManager

final class SignOutViewModel {

    private let dependency: AccountDataStore

    init(dependency: AccountDataStore) {
        self.dependency = dependency
    }
}

extension SignOutViewModel: ViewModelType {

    struct Input {
        let didButtonTapped: Observable<Void>
    }

    struct Output {
        let result: Observable<SignOutAPI.Response>
        let error: Observable<Error>
    }

    func transform(input: Input) -> Output {

        let response = input.didButtonTapped
            .flatMap { _ -> Observable<SignOutAPI.Response> in
                return self.dependency.SignOut()
            }.materialize().share(replay: 1)

        return Output(result: response.elements(), error: response.errors())
    }
}
