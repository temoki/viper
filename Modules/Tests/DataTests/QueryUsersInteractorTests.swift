import Nimble
import OHHTTPStubs
import OHHTTPStubsSwift
import Quick

@testable import Data

class QueryUsersInteractorSpec: QuickSpec {
    override func spec() {
        describe("invoke") {
            beforeEach {
                stub(condition: isHost("app-arch.example.com") && isPath("/users")) { _ in
                    let responseBody = """
                        {
                            "users": [
                                { "id" : 123, "name" : "User One" },
                                { "id" : 456, "name" : "User Two" }
                            ]
                        }
                        """.data(using: .utf8)!
                    return HTTPStubsResponse(data: responseBody, statusCode: 200, headers: nil)
                }
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            context("when success") {
                it("get users") {
                    waitUntil { done in
                        QueryUsersInteractor().invoke(()) { result in
                            switch result {
                            case .success(let output):
                                expect(
                                    QueryUsersInteractor.Output(users: [
                                        .init(id: 123, name: "User One"),
                                        .init(id: 456, name: "User Two"),
                                    ])
                                ).to(equal(output))
                            case .failure(let error):
                                fail(error.localizedDescription)
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
