import APIKit

public class SignUpAPI {
    struct Request: AppRequestType {
        typealias Response = SignUpAPI.Response

        // パラメータモデル
        var info: AuthModel

        var method: HTTPMethod {
            return APIRoutes.signUp.configurePath().method
        }

        var path: String {
            return APIRoutes.signUp.configurePath().path
        }

        var parameters: Any? {
            var data = [String: Any]()
            data["email"] = info.email
            data["password"] = info.password
            return data
        }
    }
}
