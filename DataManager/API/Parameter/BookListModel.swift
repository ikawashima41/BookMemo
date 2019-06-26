
public struct BookListModel {
    var limit: Int
    var page: Int

    public init(limit: Int, page: Int) {
        self.limit = limit
        self.page = page
    }
}
