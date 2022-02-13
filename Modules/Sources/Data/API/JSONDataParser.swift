import APIKit
import Foundation

final class JSONDataParser<T: Decodable>: APIKit.DataParser {
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        try decoder.decode(T.self, from: data)
    }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}
