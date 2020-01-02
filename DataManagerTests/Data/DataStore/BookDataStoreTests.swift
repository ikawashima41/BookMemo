import APIKit
import RxSwift
import XCTest

@testable import DataManager

class BookDataStoreTests: XCTestCase {

    private var dataStore: BookDataStoreMock!
    private var bookListModel: BookListModel!
    private var bookModel: BookModel!

    private let disposebag = DisposeBag()

    override func setUp() {
        super.setUp()

        bookListModel = BookListModel(limit: 5, page: 1)
        bookModel = BookModel(name: "Book", image: "", price: 1000, purchaseDate: "2020-01-01")
        dataStore = BookDataStoreMock()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testFetch() {
        let exp = expectation(description: "fetchHomeRequest")

        dataStore.fetch(with: bookListModel)
        .subscribe(onNext: { response in
            exp.fulfill()
        }, onError: { error in
            XCTAssert(false)
        }).disposed(by: disposebag)

        wait(for: [exp], timeout: 5.0)
    }

    func testRegister() {
        let exp = expectation(description: "BookRegistrationRequest")

        dataStore.register(with: bookModel)
        .subscribe(onNext: { response in
            exp.fulfill()
        }, onError: { error in
            XCTAssert(false)
        }).disposed(by: disposebag)

        wait(for: [exp], timeout: 5.0)
    }

    func testUpdate() {
        let exp = expectation(description: "BookDetailRequest")

        dataStore.update(with: bookModel)
        .subscribe(onNext: { response in
            exp.fulfill()
        }, onError: { error in
            XCTAssert(false)
        }).disposed(by: disposebag)

        wait(for: [exp], timeout: 5.0)
    }
}

extension BookDataStoreTests {
    class BookDataStoreMock: BookDataStore {
        func fetch(with info: BookListModel) -> Observable<FetchBookListAPI.Response> {
            return Observable.empty()
        }

        func register(with info: BookModel) -> Observable<RegisterBookAPI.Response> {
            return Observable.empty()
        }

        func update(with info: BookModel) -> Observable<UpdateBookAPI.Response> {
            return Observable.empty()
        }
    }
}
