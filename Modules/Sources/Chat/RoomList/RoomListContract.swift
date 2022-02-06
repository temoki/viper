import Foundation
import Core

public protocol RoomListView: AnyObject {
    func show(rooms: [RoomList.Room])
    func show(error message: String)
}

public protocol RoomListPresentation: AnyObject, ViewLifecycle {
    func didSelectRoom(roomId: Int)
    func didTapCreateRoomButton()
}

public protocol RoomListWireframe: AnyObject {
    func presentRoomView(roomId: Int)
    func presentCreateRoomView()
}

public protocol RoomListUseCase: AnyObject {
    func subscribeRooms()
}

public protocol RoomListInteractorOutput: AnyObject {
    func output(rooms: [RoomList.Room])
    func output(error: RoomList.Error)
}

public enum RoomList {
    public struct Room: Hashable {
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
