import Combine
import Nimble
import OHHTTPStubs
import OHHTTPStubsSwift
import Quick

@testable import Data

class SubscribeChatRoomsInteractorSpec: QuickSpec {
    override func spec() {
        describe("invoke") {
            beforeEach {
                stub(condition: isHost("app-arch.example.com") && isPath("/chat/rooms")) { _ in
                    let responseBody = """
                        {
                            "rooms": [
                                { "id": 1, "name": "Room One", "user_count": 2, "unread_count": 3, "updated_at": "2022-02-02T02:02:02+09:00"},
                                { "id": 2, "name": "Room Two", "user_count": 3, "unread_count": 4, "updated_at": "2022-02-14T14:14:14+09:00"}
                            ]
                        }
                        """.data(using: .utf8)!
                    return HTTPStubsResponse(data: responseBody, statusCode: 200, headers: nil)
                }
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            context("ポーリング2回のそれぞれのAPIリクエストが成功") {
                it("チャットルーム情報リストが2回得られる") {
                    let repeatCount = 2
                    var cancellables = Set<AnyCancellable>()
                    waitUntil { done in
                        SubscribeChatRoomsInteractor(polingInterval: 0.1, repeatCount: repeatCount)
                            .invoke(())
                            .collect()
                            .sink { completion in
                                if case .failure(let error) = completion {
                                    fail(error.localizedDescription)
                                }
                                done()
                            } receiveValue: { outputs in
                                let expectedOutput = SubscribeChatRoomsInteractor.Output(
                                    chatRooms: [
                                        .init(
                                            id: 1, name: "Room One", userCount: 2, unreadCount: 3,
                                            updatedAt: Date(timeIntervalSince1970: 1_643_734_922)),
                                        .init(
                                            id: 2, name: "Room Two", userCount: 3, unreadCount: 4,
                                            updatedAt: Date(timeIntervalSince1970: 1_644_815_654)),
                                    ])
                                expect(Array(repeating: expectedOutput, count: repeatCount))
                                    .to(equal(Array(outputs)))
                            }
                            .store(in: &cancellables)
                    }
                }
            }
        }
    }
}
