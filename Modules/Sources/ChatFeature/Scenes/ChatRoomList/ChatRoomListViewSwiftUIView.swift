import SwiftUI

class ChatRoomListViewSwiftUIState: ObservableObject {
    @Published var chatRooms: [ChatRoomList.ChatRoom]

    init(chatRooms: [ChatRoomList.ChatRoom] = []) {
        self.chatRooms = chatRooms
    }
}

struct ChatRoomListViewSwiftUIView: View {
    @ObservedObject var state: ChatRoomListViewSwiftUIState
    weak var presentation: ChatRoomListPresentation?

    init(state: ChatRoomListViewSwiftUIState, presentation: ChatRoomListPresentation? = nil) {
        self.state = state
        self.presentation = presentation
    }

    var body: some View {
        List(state.chatRooms, id: \.id) { chatRoom in
            Button(
                action: { presentation?.didSelectChatRoom(chatRoomId: chatRoom.id) },
                label: {
                    HStack(alignment: .center, spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(chatRoom.name)")
                                .font(.headline)
                            Text(
                                "\(dateFormatter.string(from: chatRoom.updatedAt)) (\(chatRoom.userCount) users)"
                            )
                            .font(.caption)
                        }
                        Spacer()
                        if chatRoom.unreadCount > 0 {
                            Text("\(chatRoom.unreadCount)")
                                .foregroundColor(.secondary)
                        }
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
            )
        }.listStyle(.plain)
    }

    private let dateFormatter = ISO8601DateFormatter()
}

struct ChatRoomListViewSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomListViewSwiftUIView(
            state: .init(
                chatRooms: (1...10).map {
                    .init(
                        id: $0, name: "Room \($0)", userCount: 1 + $0, unreadCount: $0 - 1,
                        updatedAt: .init())
                }
            )
        )
        .previewLayout(.device)
    }
}
