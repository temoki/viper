import Foundation
import UIKit.UIViewController

public protocol ViewAssembler {
    func assembleChatView(_ scene: ChatScene) -> UIViewController
}

public enum ChatScene {
    case roomList
    case room(roomId: Int)
    case createRoom

    public var name: String {
        switch self {
        case .roomList:         return "RoomList"
        case .room(let roomId): return "Room-\(roomId)"
        case .createRoom:       return "CreateRoom"
        }
    }
}
