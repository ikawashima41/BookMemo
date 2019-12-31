//
//  LoginViewModelTest.swift
//  BookMemoTests
//
//  Created by Iichiro Kawashima on 2019/12/31.
//  Copyright © 2019 nabezawa. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import DataManager

@testable import BookMemo

class SignInViewModelTests: XCTestCase {

    var viewModel: SignInViewModel!
    let disposeBag = DisposeBag()
    var scheduler: TestScheduler!

    override func setUp() {
        let dataStore = AccountDataStoreMock()
        viewModel = SignInViewModel(dependency: dataStore)
        scheduler = TestScheduler(initialClock: 1)
    }

    override func tearDown() {

    }

    func test_validateSignInForm() {
        let emailTextobserbavle = scheduler.createHotObservable([
            Recorded.next(5, "email"),
            Recorded.next(15, "eamil@gmail.com")
            ]).asObservable()

        let passwordTextObservable = scheduler.createHotObservable([
            Recorded.next(10, ""),
            Recorded.next(20, "password")
            ]).asObservable()

        let input = SignInViewModel.Input(didSignInButtonTapped: Observable.never(), didSignupButtonTapped: Observable.never(), emailText: emailTextobserbavle, passwordText: passwordTextObservable)

        let output = viewModel.transform(input: input)

        let obserber = scheduler.createObserver(Bool.self)

        output.isValid
            .bind(to: obserber)
            .disposed(by: disposeBag)

        scheduler.start()


        let expectedEvent = [
            Recorded.next(10, false),
            Recorded.next(15, false),
            Recorded.next(20, true)
        ]

        XCTAssertEqual(expectedEvent, obserber.events)

    }
}

extension SignInViewModelTests {

    class AccountDataStoreMock: AccountDataStore {

        func SignIn(with info: AuthModel) -> Observable<SignInAPI.Response> {
            return Observable.never()
        }

        func signUp(with info: AuthModel) -> Observable<SignUpAPI.Response> {
            return Observable.never()
        }

        func SignOut() -> Observable<SignOutAPI.Response> {
            return Observable.never()
        }
    }
}
