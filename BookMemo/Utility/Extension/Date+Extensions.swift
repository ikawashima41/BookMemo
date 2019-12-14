import Foundation

extension Date {
    static func convertToString(from date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy/MM/dd"
        return dateFormat.string(from: date)
    }

    static func convertToDate(from String: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        return dateFormat.date(from: String) ?? Date()
    }
}
