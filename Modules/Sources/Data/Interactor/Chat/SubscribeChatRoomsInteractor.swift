import APIKit
import ChatUseCase
import Combine
import Core
import Foundation

public final class SubscribeChatRoomsInteractor: PublisherUseCase {
    public typealias Input = Void
    public typealias Output = SubscribeChatRoomsUseCaseOutput
    public typealias Failure = Never

    public init(session: Session = .shared, polingInterval: TimeInterval = 5, repeatCount: Int = 12)
    {
        self.session = session
        self.polingInterval = polingInterval
        self.repeatCount = repeatCount
    }

    public func invoke(_ input: Input) -> AnyPublisher<Output, Failure> {
        guard repeatCount > 0 else {
            return Empty<Output, Failure>(completeImmediately: true).eraseToAnyPublisher()
        }

        let session = self.session
        let firstQuery = Self.queryChatRoomsTask(with: session)
        guard repeatCount > 1 else {
            return Self.queryChatRoomsTask(with: session)
        }

        return firstQuery.append(
            Timer
                .publish(every: polingInterval, on: .main, in: .common)
                .autoconnect()
                .prefix(repeatCount - 1)
                .flatMap { _ in
                    Self.queryChatRoomsTask(with: session)
                }
        ).eraseToAnyPublisher()
    }

    private let session: Session
    private let polingInterval: TimeInterval
    private let repeatCount: Int

    private static func queryChatRoomsTask(with session: Session) -> AnyPublisher<Output, Failure> {
        session
            .sessionTaskPublisher(for: QueryChatRoomsRequest())
            .replaceError(with: .init(rooms: []))
            .map { responseBody in
                Output(
                    chatRooms: responseBody.rooms.map {
                        .init(
                            id: $0.id,
                            name: $0.name,
                            userCount: $0.userCount,
                            unreadCount: $0.unreadCount,
                            updatedAt: $0.updatedAt)
                    })
            }
            .eraseToAnyPublisher()
    }
}
