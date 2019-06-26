import APIKit

public class SignInAPI {
    struct Request: AppRequestType {
        typealias Response = SignInAPI.Response

        // パラメータモデル
        var info: AuthModel

        var method: HTTPMethod {
            return APIRoutes.SignIn.configurePath().method
        }

        var path: String {
            return APIRoutes.SignIn.configurePath().path
        }

        var parameters: Any? {
            var data = [String: Any]()
            data["email"] = info.email
            data["password"] = info.password
            return data
        }
    }
}


