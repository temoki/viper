import Foundation
import Core
import UseCase

public protocol RoomListViewContract: AnyObject {
    func show(rooms: [RoomList.Room])
}

public protocol RoomListPresenterContract: AnyObject, ViewLifecycle {
    func didSelectRoom(roomId: Int)
    func didTapCreateRoomButton()
}

public protocol RoomListRouterContract: AnyObject {
    func presentRoomView(roomId: Int)
    func presentRoomCreateView()
}

public struct RoomListUseCases {
    public let publishRooms: PublishChatRoomsUseCase

    public init(publishRooms: PublishChatRoomsUseCase) {
        self.publishRooms = publishRooms
    }
}

public enum RoomList {
    public typealias Room = PublishChatRoomsUseCaseOutput.ChatRoom
    
    public enum Error {
        case nerworkError(Swift.Error)
        case unknown(Swift.Error)
    }
}

extension RoomList.Error: CustomNSError {
    public static let errorDomain: String = "RoomList.Error"

    public var errorCode: Int {
        switch self {
        case .nerworkError:
            return -1
            
        case .unknown:
            return -99
        }
    }

    public var errorUserInfo: [String: Any] {
        switch self {
        case let .nerworkError(error):
            return [NSUnderlyingErrorKey: error as NSError]
            
        case let .unknown(error):
            return [NSUnderlyingErrorKey: error as NSError]
        }
    }
}
