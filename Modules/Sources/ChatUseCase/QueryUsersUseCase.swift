import Core
import Foundation

public typealias QueryUsersUseCase = AnyCallbackUseCase<
    Void, QueryUsersUseCaseOutput, Error
>

public struct QueryUsersUseCaseOutput: Equatable {
    public struct User: Hashable {
        public let id: Int
        public let name: String

        public init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
    }

    public let users: [User]

    public init(users: [QueryUsersUseCaseOutput.User]) {
        self.users = users
    }
}

public final class QueryUsersInteractorStub: CallbackUseCase {
    public typealias Input = Void
    public typealias Output = QueryUsersUseCaseOutput
    public typealias Failure = Error

    public init() {}

    public func invoke(
        _ input: Input, callback: @escaping (Result<Output, Error>) -> Void
    ) {
        DispatchQueue.main.async {
            callback(
                .success(
                    Output(
                        users: Array(1...30).map {
                            Output.User(id: $0, name: "User \($0)")
                        })))
        }
    }

    public func cancel() {
    }
}
