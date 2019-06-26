import APIKit
import RxSwift
import XCTest
import RxTest
import RxBlocking

@testable import DataManager

class BookDataStoreTests: XCTestCase {

    private let dataStore = BookDataStoreImpl()

    private let disposebag = DisposeBag()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFetch() {
        let model = BookListModel(limit: 5, page: 1)
        let exp = expectation(description: "fetchHomeRequest")

        dataStore.fetch(with: model)
        .subscribe(onNext: { response in
            print(response)
            exp.fulfill()
        }, onError: { error in
            print(error)
            XCTAssert(false)
        }).disposed(by: disposebag)

        wait(for: [exp], timeout: 5.0)
    }

    func testRegister() {
        let model = BookModel(name: "花火", image: "image", price: 400, purchaseDate: "2019-07-31")
        let exp = expectation(description: "BookRegistrationRequest")

        dataStore.register(with: model)
        .subscribe(onNext: { response in
            print(response)
            exp.fulfill()
        }, onError: { error in
            print(error)
            XCTAssert(false)
        }).disposed(by: disposebag)

        wait(for: [exp], timeout: 5.0)
    }

    func testUpdate() {
        let model = BookModel(name: "花火祭り", image: "image", price: 2000, purchaseDate: "2019-08-04", id: 1508)
        let exp = expectation(description: "BookDetailRequest")

        dataStore.update(with: model)
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
