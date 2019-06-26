
public struct BookModel {
    var name: String
    var image: String
    var price: Int
    var purchaseDate: String
    var id: Int?

    public init(name: String, image: String, price: Int, purchaseDate: String, id: Int? = nil) {
        self.name = name
        self.image = image
        self.price = price
        self.purchaseDate = purchaseDate
        self.id = id
    }
}
