import RxSwift
import DataManager

final class HomeViewModel {

    private struct Constant {
        static let limit: Int = 5
    }

    private let dependency: BookDataStore

    lazy var books: [BookInfomation] = []

    private var pageCount = 1

    init(dependency: BookDataStore) {
        self.dependency = dependency
    }
}

extension HomeViewModel: ViewModelType {

    struct Input {
        let didReloadButtonTapped: Observable<Void>
        let viewWillAppear: Observable<Void>
    }

    struct Output {
        let result: Observable<FetchBookListAPI.Response>
        let error: Observable<Error>
        let pagingResult: Observable<FetchBookListAPI.Response>
        let pagingError: Observable<Error>
    }

    func transform(input: Input) -> Output {

        let paging = input.viewWillAppear
            .flatMap { [weak self] _ -> Observable<Event<FetchBookListAPI.Response>> in
                guard let self = self else {
                    return Observable.empty()
                }

                let model = BookListModel(
                    limit: Constant.limit,
                    page: self.pageCount
                )
                self.pageCount += 1

                return self.dependency.fetch(with: model)
                .materialize()
            }.share(replay: 1)

        let response = input.didReloadButtonTapped
            .flatMap { [weak self] _ -> Observable<Event<FetchBookListAPI.Response>> in
                guard let self = self else { return Observable.empty() }

                let model = BookListModel(
                    limit: Constant.limit,
                    page: self.pageCount
                )
                self.pageCount += 1

                return self.dependency.fetch(with: model)
                .materialize()
            }.share(replay: 1)

        return Output(
            result: response.elements(),
            error: response.errors(),
            pagingResult: paging.elements(),
            pagingError: paging.errors()
        )
    }
}
