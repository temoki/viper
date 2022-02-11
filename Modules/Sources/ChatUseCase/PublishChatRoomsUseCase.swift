import Combine
import Core
import Foundation

public typealias PublishChatRoomsUseCase = AnyPublisherUseCase<
    Void, PublishChatRoomsUseCaseOutput, Never
>

public struct PublishChatRoomsUseCaseOutput {
    public struct ChatRoom: Hashable {
        public let id: Int
        public let name: String
        public let userCount: Int
        public let unreadCount: Int
        public let updatedAt: Date

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

    public let chatRooms: [ChatRoom]

    public init(chatRooms: [ChatRoom]) {
        self.chatRooms = chatRooms
    }
}

public final class PublishChatRoomsInteractorStub: PublisherUseCase {
    public typealias Input = Void
    public typealias Output = PublishChatRoomsUseCaseOutput
    public typealias Failure = Never

    public init() {}

    public func invoke(_ input: Input) -> AnyPublisher<Output, Failure> {
        let initialRooms = Array(1...30).map {
            Output.ChatRoom(
                id: $0,
                name: "Chat Room \($0)",
                userCount: Int.random(in: 2...10),
                unreadCount: 0,
                updatedAt: Date()
            )
        }

        let firstEvent = Future<[Output.ChatRoom], Never> { promise in
            promise(.success(initialRooms))
        }

        let timerEvent =
            Timer
            .publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .scan(
                initialRooms,
                { rooms, date in
                    var newRooms = rooms
                    let oldRoom = newRooms.remove(at: Int.random(in: 0..<rooms.count))
                    let newRoom = Output.ChatRoom(
                        id: oldRoom.id,
                        name: oldRoom.name,
                        userCount: oldRoom.userCount,
                        unreadCount: oldRoom.unreadCount + 1,
                        updatedAt: Date()
                    )
                    newRooms.insert(newRoom, at: 0)
                    return newRooms
                })

        return
            firstEvent
            .append(timerEvent)
            .map {
                Output(chatRooms: $0)
            }
            .eraseToAnyPublisher()
    }
}
