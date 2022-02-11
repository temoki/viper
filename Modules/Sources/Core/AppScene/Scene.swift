public enum Scene {
    case chatRoomList
    case chatRoom(roomId: Int)
    case chatRoomCreate
}

extension Scene {
    public var name: String {
        switch self {
        case .chatRoomList:
            return "ChatRoomList"
        case .chatRoom(let roomId):
            return "ChatRoom-\(roomId)"
        case .chatRoomCreate:
            return "ChatRoomCreate"
        }
    }
}
