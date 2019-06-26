import APIKit
import RxSwift

public protocol AccountDataStore {
    func SignIn(with info: AuthModel) -> Observable<SignInAPI.Response>
    func signUp(with info: AuthModel) -> Observable<SignUpAPI.Response>
    func SignOut() -> Observable<SignOutAPI.Response>
}

public struct AccountDataStoreImpl: AccountDataStore {

    public init() {}

    public func SignIn(with info: AuthModel) -> Observable<SignInAPI.Response> {
        let request = SignInAPI.Request(info: info)
        return Session.rx_sendRequest(request: request)
                .do(onNext: { result in
                    let token = result.result.token
                    LocalDataStore.saveToken(value: token)
        })
    }

    public func signUp(with info: AuthModel) -> Observable<SignUpAPI.Response> {
        let request = SignUpAPI.Request(info: info)
        return Session.rx_sendRequest(request: request)
                .do(onNext: { result in
                    let token = result.result.token
                    LocalDataStore.saveToken(value: token)
                })
    }

    public func SignOut() -> Observable<SignOutAPI.Response> {
        let request = SignOutAPI.Request()
        return Session.rx_sendRequest(request: request)
                .do(onNext: { result in
                    LocalDataStore.clearToken()
                })
    }
}

struct AccountDataStoreFactory {
    static func createUserAccountDataStore() -> AccountDataStore {
        return AccountDataStoreImpl()
    }
}
