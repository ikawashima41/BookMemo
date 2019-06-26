
extension FetchBookListAPI {
    public struct Response: Decodable {
        public var status: Int
        public var result: [Book]
    }
}

public struct Book: Decodable {
    public var id: Int
    public var name: String
    public var image: String?
    public var price: Int?
    public var purchaseDate: String?

    enum CodingKeys: String, CodingKey {
        case purchaseDate = "purchase_date"
        case id
        case name
        case image
        case price
    }
}
