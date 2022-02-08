import Foundation
import Combine

public final class PublishChatRoomsUseCase: PublisherUseCase {
    public typealias Parameters = Void
    public typealias Success = [ChatRoom]
    public typealias Failure = Never
    
    public struct ChatRoom: Hashable {
        public let id: Int
        public let name: String
        public let userCount: Int
        public let unreadCount: Int

        public init(id: Int, name: String, userCount: Int, unreadCount: Int) {
            self.id = id
            self.name = name
            self.userCount = userCount
            self.unreadCount = unreadCount
        }
    }
    
    public func invoke(_ parameters: Void) -> AnyPublisher<[Int], Never> {
        fatalError("Not yet implemented")
    }
}
