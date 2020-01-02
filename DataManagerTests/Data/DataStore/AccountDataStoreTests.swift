import APIKit
import RxSwift
import XCTest

@testable import DataManager

class AccountDataStoreTests: XCTestCase {

    let disposebag = DisposeBag()

    var model: AuthModel!
    var dataStore: AccountDataStoreMock!

    override func setUp() {
        super.setUp()

        model = AuthModel(email: "kawashima@gmail.com", password: "password")
        dataStore = AccountDataStoreMock()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSignIn() {
        let exp = expectation(description: "SignInRequest")

        dataStore.SignIn(with: model)
            .subscribe(onNext: { response in
                print(response)
                exp.fulfill()
            }, onError: { error in
                print(error)
                XCTAssert(false)
            }).disposed(by: disposebag)

        wait(for: [exp], timeout: 5.0)
    }

    func testSignup() {
        let exp = expectation(description: "signupRequest")

        dataStore.signUp(with: model)
            .subscribe(onNext: { response in
                print(response)
                exp.fulfill()
            }, onError: { error in
                print(error)
                XCTAssert(false)
            }).disposed(by: disposebag)

        wait(for: [exp], timeout: 5.0)
    }

    func testSignOut() {
        let exp = expectation(description: "signupRequest")

        dataStore.SignOut()
            .subscribe(onNext: { response in
                print(response)
                exp.fulfill()
            }, onError: { error in
                print(error)
                XCTAssert(false)
            }).disposed(by: disposebag)

        wait(for: [exp], timeout: 5.0)
    }
}

extension AccountDataStoreTests {

    // https://dev.classmethod.jp/smartphone/swift3-json/
    class AccountDataStoreMock: AccountDataStore {
        func SignIn(with info: AuthModel) -> Observable<SignInAPI.Response> {

            // ローカルのファイル/ 記述したテストコードからparseする方法
            // https://qiita.com/tamappe/items/72308a2445cdd2fb661d
            let json = """
                "id": 1,
                "first_name": "Taro",
                "last_name": "Tanaka",
                "title": "first_data",
                "create_at": "2018-12-30T15:03:01.012345"
            """

            let data = try? Data(base64Encoded: json)

            let response =  SignInAPI.Response(
                status: 200,
                result: User(
                    id: 1,
                    email: info.email,
                    token: "token"
                )
            )
            return Observable.of(response)
        }

        func signUp(with info: AuthModel) -> Observable<SignUpAPI.Response> {
            return Observable.empty()
        }

        func SignOut() -> Observable<SignOutAPI.Response> {
            return Observable.empty()
        }
    }
}
