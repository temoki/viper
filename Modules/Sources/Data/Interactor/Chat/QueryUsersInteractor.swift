import APIKit
import ChatUseCase
import Core
import Foundation

public final class QueryUsersInteractor: CallbackUseCase {
    public typealias Input = Void
    public typealias Output = QueryUsersUseCaseOutput
    public typealias Failure = Error

    public init(session: Session = .shared) {
        self.session = session
    }

    public func invoke(
        _ input: Input, callback: @escaping (Result<Output, Failure>) -> Void
    ) {
        sessionTask = session.send(QueryUsersRequest()) { result in
            switch result {
            case .success(let response):
                callback(
                    .success(
                        .init(
                            users: response.users.map { user in
                                Output.User(
                                    id: user.id,
                                    name: user.name
                                )
                            })))

            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    public func cancel() {
        sessionTask?.cancel()
        sessionTask = nil
    }

    private let session: Session
    private var sessionTask: SessionTask?
}
