import APIKit
import RxSwift
import XCTest

@testable import DataManager

class AccountDataStoreTests: XCTestCase {

    let disposebag = DisposeBag()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSignIn() {
        let dataStore = AccountDataStoreImpl()
        let model = AuthModel(email: "", password: "")
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
        let dataStore = AccountDataStoreImpl()
        let model = AuthModel(email: "", password: "")
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
        let dataStore = AccountDataStoreImpl()
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
