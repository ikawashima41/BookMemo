import XCTest
import RxBlocking

@testable import BookMemo

class BookMemoDefaultTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOutputObjectInjection() {

        let spy = ValidatorHandlerSpy()
        let validator = NumberValidator()

        validator.validate(
            inputText: "123",
            output: spy
        )

        XCTAssertEqual(spy.callArgs, [.success])

    }

    func testInputObjectInjection() {
        let expectation = self.expectation(description: "API Request")

        // テストする値を事前に指定する
        let apiManagerStub = APIManagerStub(
            returnedValue: "test-user"
        )
        let api = UserNameUpperCasedAPI()

        api.getUserName(
            apiManger: apiManagerStub,
            callback: { upperCased in
            XCTAssertEqual(upperCased, "TEST-USER")
            expectation.fulfill()
        })

        self.wait(for: [expectation], timeout: 0.5)
    }

    func testSingleMethodStubSpy() {
        let spy = NavigatorSpy()

        let viewController = MyViewController(
            navigatingBy: spy
        )
        viewController.didButtonTap(UIButton())

        // ボタンの押下されたカウント
        XCTAssertEqual(spy.callArgs.count, 1)
    }

    func testDependencybag() {
        let spy = NavigatorSpy()
        let vc = ViewControllerA(
            using: .create(),
            navigatingBy: spy
        )

        vc.doSomething()

        XCTAssertEqual(spy.callArgs.count, 0)
    }

    func testLoggingObserver() {
        let model = ExampleModel()

        model.doSomething()

        XCTAssertEqual(model.currentState, true)
    }

    func testRxEventBlocker() {
        let model = RequestModel()

        model.fetch()

        let result = try! model
            .resultDidChange
            .filter { $0 != nil } // 初期値がnilとなるため除外する
            .take(1)
            .toBlocking() //complete になるまでコードの実行をやめる
            .single()!

        XCTAssertEqual(result, "Fetched!")
    }

    func testStateMachineModel() {
        let model = RequestModelState()
        model.currentState = .fetching
        model.fetch()

        let result = try! model
            .didChange
            .take(1)
            .toBlocking()
            .first()

        //XCTAssertEqual(result, .fetching)
    }
}



