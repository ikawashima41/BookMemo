import Foundation

public class LocalDataStore {
    public static func getToken() -> String {
        return getString(with: "token")
    }

    public static func saveToken(value: String) {
        saveString(value: value, with: "token")
    }

    public static func clearToken() {
        saveString(value: "", with: "token")
    }
}

extension LocalDataStore {
    public static func getString(with key: String) -> String {
        let userDefault = UserDefaults.standard
        return userDefault.string(forKey: key) ?? ""
    }

    public static func saveString(value: String, with key: String) {
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key)
    }
}
