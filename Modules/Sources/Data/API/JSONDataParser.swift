import APIKit
import Foundation

final class JSONDataParser<T: Decodable>: APIKit.DataParser {
    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        try JSONDecoder().decode(T.self, from: data)
    }
}
