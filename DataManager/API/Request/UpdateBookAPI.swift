import APIKit

public class UpdateBookAPI {
    struct Request: AppRequestType {
        typealias Response = UpdateBookAPI.Response

        // パラメータモデル
        var info: BookModel

        var headerFields: [String: String] {
            return ["Authorization": LocalDataStore.getToken()]
        }

        var method: HTTPMethod {
            return APIRoutes.updateBook.configurePath().method
        }

        var path: String {
            return APIRoutes.updateBook.configurePath().path + String(describing: info.id)
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
