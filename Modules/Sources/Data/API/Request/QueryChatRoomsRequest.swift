import APIKit
import Foundation

struct QueryChatRoomsRequest: AppArchRequest {
    struct Response: Decodable {
        struct ChatRoom: Decodable {
            let id: Int
            let name: String
            let userCount: Int
            let unreadCount: Int
            let updatedAt: Date
        }

        let rooms: [ChatRoom]
    }

    var method: HTTPMethod {
        .get
    }

    var path: String {
        "/chat/rooms"
    }
}
