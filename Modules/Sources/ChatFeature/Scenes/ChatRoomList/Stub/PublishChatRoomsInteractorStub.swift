import ChatUseCase
import Combine
import Core
import Foundation

public final class PublishChatRoomsInteractorStub: PublisherUseCase {
    public typealias Parameters = Void
    public typealias Success = PublishChatRoomsUseCaseOutput
    public typealias Failure = Never

    public init() {}

    public func invoke(_ parameters: Void) -> AnyPublisher<PublishChatRoomsUseCaseOutput, Never> {
        let initialRooms = Array(1...30).map {
            PublishChatRoomsUseCaseOutput.ChatRoom(
                id: $0,
                name: "Chat Room \($0)",
                userCount: Int.random(in: 2...10),
                unreadCount: 0,
                updatedAt: Date()
            )
        }

        let firstEvent = Future<[PublishChatRoomsUseCaseOutput.ChatRoom], Never> { promise in
            promise(.success(initialRooms))
        }

        let timerEvent =
            Timer
            .publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .scan(
                initialRooms,
                { rooms, date in
                    var newRooms = rooms
                    let oldRoom = newRooms.remove(at: Int.random(in: 0..<rooms.count))
                    let newRoom = PublishChatRoomsUseCaseOutput.ChatRoom(
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
                PublishChatRoomsUseCaseOutput(chatRooms: $0)
            }
            .eraseToAnyPublisher()
    }
}
