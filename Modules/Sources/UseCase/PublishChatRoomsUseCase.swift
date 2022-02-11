import Foundation
import Combine

public typealias PublishChatRoomsUseCase = AnyPublisherUseCase<Void, PublishChatRoomsUseCaseOutput, Never>

public struct PublishChatRoomsUseCaseOutput {
    public struct ChatRoom: Hashable {
        public var id: Int
        public var name: String
        public var userCount: Int
        public var unreadCount: Int
        public var updatedAt: Date

        public init(
            id: Int,
            name: String,
            userCount: Int,
            unreadCount: Int,
            updatedAt: Date
        ) {
            self.id = id
            self.name = name
            self.userCount = userCount
            self.unreadCount = unreadCount
            self.updatedAt = updatedAt
        }
    }
    
    public var rooms: [ChatRoom]
    
    public init(rooms: [ChatRoom]) {
        self.rooms = rooms
    }
}
