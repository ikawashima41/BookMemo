
extension FetchBookListAPI {
    public struct Response: Decodable {
        public var status: Int
        public var result: [Book]
    }
}
