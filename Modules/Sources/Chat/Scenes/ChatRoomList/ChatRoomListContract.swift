import Foundation
import Core
import UseCase

public protocol ChatRoomListView: AnyObject {
    func show(chatRooms: [ChatRoomList.ChatRoom])
}

public protocol ChatRoomListPresentation: AnyObject, ViewLifecycle {
    func didSelectChatRoom(chatRoomId: Int)
    func didTapCreateChatRoomButton()
}

public protocol ChatRoomListWireframe: AnyObject {
    func presentChatRoomView(chatRoomId: Int)
    func presentChatRoomCreateView()
}

public struct ChatRoomListUseCases {
    public let publishChatRooms: PublishChatRoomsUseCase

    public init(publishChatRooms: PublishChatRoomsUseCase) {
        self.publishChatRooms = publishChatRooms
    }
}

public enum ChatRoomList {
    public typealias ChatRoom = PublishChatRoomsUseCaseOutput.ChatRoom
    
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
        case let .unknown(error):
            return [NSUnderlyingErrorKey: error as NSError]
        }
    }
}
