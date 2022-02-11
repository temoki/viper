import APIKit
import Foundation

protocol AppArchRequest: APIKit.Request {
}

extension AppArchRequest {
    var baseURL: URL {
        URL(string: "https://app-arch.example.com")!
    }
}

extension AppArchRequest where Self.Response: Decodable {
    var dataParser: DataParser {
        JSONDataParser<Response>()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        if let response = object as? Response {
            return response
        }
        throw ResponseError.unexpectedObject(object)
    }
}
