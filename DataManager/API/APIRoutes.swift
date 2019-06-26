import APIKit

public enum APIRoutes {
    case SignIn             // ログイン
    case signUp             // 新規登録
    case SignOut            // ログアウト
    case fetchBook          // 書籍一覧取得
    case registerBook       // 書籍登録
    case updateBook         // 書籍情報取得

    public func configurePath() -> (method: HTTPMethod, path: String) {
        switch self {
        case .SignIn:               return (.post, "/SignIn")
        case .signUp:               return (.post, "/sign_up")
        case .SignOut:              return (.delete, "/SignOut")
        case .fetchBook:            return (.get, "/books")
        case .registerBook:         return (.post, "/books")
        case .updateBook:           return (.put, "/books")
        }
    }
}
