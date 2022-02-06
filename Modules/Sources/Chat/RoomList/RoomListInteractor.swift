import Foundation
import Core

public final class RoomListInteractor: RoomListUseCase, DependencyInjectable {
    public init() {}
    
    // MARK: - DependencyInjectable
    
    public struct Dependency {
        public init(output: RoomListInteractorOutput? = nil) {
            self.output = output
        }
        
        public weak var output: RoomListInteractorOutput?
    }
    
    public func inject(_ dependency: Dependency) {
        self.dependency = dependency
    }
    
    // MARK: - RoomListUseCase

    public func subscribeRooms() {
        roomsUpdateTimer?.invalidate()
        roomsUpdateTimer = Timer.scheduledTimer(
            withTimeInterval: 3,
            repeats: true,
            block: { [weak self] _ in
                guard let self = self else { return }
                // Simulate new message
                let index = Int.random(in: 0..<self.rooms.count)
                let old = self.rooms.remove(at: index)
                let new = RoomList.Room(id: old.id, name: old.name, userCount: old.userCount, unreadCount: old.unreadCount + 1)
                self.rooms.insert(new, at: 0)
                self.dependency.output?.output(rooms: self.rooms)
            })
        
        dependency.output?.output(rooms: rooms)
    }
    
    // MARK: - Private
    
    private var dependency: Dependency!
    
    private var rooms: [RoomList.Room] = Array(1...30).map {
        .init(id: $0, name: "Room \($0)", userCount: Int.random(in: 2...10), unreadCount: 0)
    }
    
    private var roomsUpdateTimer: Timer?
}
