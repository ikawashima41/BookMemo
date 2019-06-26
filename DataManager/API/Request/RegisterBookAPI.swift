import APIKit

public class RegisterBookAPI {
    struct Request: AppRequestType {
        typealias Response = RegisterBookAPI.Response

        // パラメータモデル
        var info: BookModel

        var headerFields: [String: String] {
            return ["Authorization": LocalDataStore.getToken()]
        }

        var method: HTTPMethod {
            return APIRoutes.registerBook.configurePath().method
        }

        var path: String {
            return APIRoutes.registerBook.configurePath().path
        }

        var parameters: Any? {
            var data = [String: Any]()
            data["name"] = info.name
            data["image"] = info.image
            data["price"] = info.price
            data["purchase_date"] = info.purchaseDate
            return data
        }
    }
}
