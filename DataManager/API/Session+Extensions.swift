import APIKit
import RxSwift

extension Session {
    public func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return Observable.create { observer in
            let task = self.send(request) { result in
                switch result {
                case .success(let res):
                    observer.onNext(res)
                case .failure(.responseError(let responseError as APPErrorCode)):
                    observer.onError(responseError)
                case .failure(let err):
                    observer.onError(err)
                }
            }
            return Disposables.create { [weak task] in
                task?.cancel()
            }
        }
    }

    public class func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
}
