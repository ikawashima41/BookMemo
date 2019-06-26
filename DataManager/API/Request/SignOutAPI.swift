import APIKit

public class SignOutAPI {
    struct Request: AppRequestType {
        typealias Response = SignOutAPI.Response

        var headerFields: [String: String] {
            return ["Authorization": LocalDataStore.getToken()]
        }

        var method: HTTPMethod {
            return APIRoutes.SignOut.configurePath().method
        }

        var path: String {
            return APIRoutes.SignOut.configurePath().path
        }
    }
}
