import ChatUseCase
import Core
import Foundation

@MainActor
public protocol ChatRoomListView: AnyObject {
    func show(chatRooms: [ChatRoomList.ChatRoom])
}

@MainActor
public protocol ChatRoomListPresentation: AnyObject, ViewLifecycle {
    func didSelectChatRoom(chatRoomId: Int)
    func didTapCreateChatRoomButton()
}

@MainActor
public protocol ChatRoomListWireframe: AnyObject {
    func presentChatRoomView(chatRoomId: Int)
    func presentChatRoomCreateView()
}

public struct ChatRoomListUseCases {
    public let subscribeChatRooms: SubscribeChatRoomsUseCase

    public init(subscribeChatRooms: SubscribeChatRoomsUseCase) {
        self.subscribeChatRooms = subscribeChatRooms
    }
}

public enum ChatRoomList {
    public typealias ChatRoom = SubscribeChatRoomsUseCaseOutput.ChatRoom

    public enum Error {
        case unknown(Swift.Error)
    }
}

extension ChatRoomList.Error: CustomNSError {
    public static let errorDomain: String = "RoomList.Error"

    public var errorCode: Int {
        switch self {
        case .unknown:
            return -99
        }
    }

    public var errorUserInfo: [String: Any] {
        switch self {
        case .unknown(let error):
            return [NSUnderlyingErrorKey: error as NSError]
        }
    }
}
