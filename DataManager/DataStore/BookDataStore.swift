import APIKit
import RxSwift

public protocol BookDataStore {
    func fetch(with info: BookListModel) -> Observable<FetchBookListAPI.Response>
    func register(with info: BookModel) -> Observable<RegisterBookAPI.Response>
    func update(with info: BookModel) -> Observable<UpdateBookAPI.Response>
}

public struct BookDataStoreImpl: BookDataStore {

    public func fetch(with info: BookListModel) -> Observable<FetchBookListAPI.Response> {
        let request = FetchBookListAPI.Request(info: info)
        return Session.rx_sendRequest(request: request)
    }

    public func register(with info: BookModel) -> Observable<RegisterBookAPI.Response> {
        let request = RegisterBookAPI.Request(info: info)
        return Session.rx_sendRequest(request: request)
    }

    public func update(with info: BookModel) -> Observable<UpdateBookAPI.Response> {
        let request = UpdateBookAPI.Request(info: info)
        return Session.rx_sendRequest(request: request)
    }
}

public struct BookDataStoreFactory {
    public static func make() -> BookDataStore {
        return BookDataStoreImpl()
    }
}
