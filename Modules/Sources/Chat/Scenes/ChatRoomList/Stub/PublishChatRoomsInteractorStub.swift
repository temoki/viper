import Foundation
import Combine
import UseCase

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
        
        let timerEvent = Timer
            .publish(every: 3, on: .main, in: .common)
            .autoconnect()
            .scan(initialRooms, { rooms, date in
                var newRooms = rooms
                var room = newRooms.remove(at: Int.random(in: 0..<rooms.count))
                room.unreadCount += 1
                room.updatedAt = date
                newRooms.insert(room, at: 0)
                return newRooms
            })

        return firstEvent
            .append(timerEvent)
            .map {
                PublishChatRoomsUseCaseOutput(rooms: $0)
            }
            .eraseToAnyPublisher()
    }
}
