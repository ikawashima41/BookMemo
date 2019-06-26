import APIKit

public class FetchBookListAPI {
    struct Request: AppRequestType {
        typealias Response = FetchBookListAPI.Response

        // パラメータモデル
        var info: BookListModel

        var headerFields: [String: String] {
            return ["Authorization": LocalDataStore.getToken()]
        }

        var method: HTTPMethod {
            return APIRoutes.fetchBook.configurePath().method
        }

        var path: String {
            return APIRoutes.fetchBook.configurePath().path
        }

        var parameters: Any? {
            var data = [String: Any]()
            data["limit"] = info.limit
            data["page"] = info.page
            return data
        }
    }
}
