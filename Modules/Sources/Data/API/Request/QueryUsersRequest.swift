import APIKit
import Foundation

struct QueryUsersRequest: AppArchRequest {
    struct Response: Decodable {
        struct User: Decodable {
            let id: Int
            let name: String
        }

        let users: [User]
    }

    var method: HTTPMethod {
        .get
    }

    var path: String {
        "/users"
    }
}
