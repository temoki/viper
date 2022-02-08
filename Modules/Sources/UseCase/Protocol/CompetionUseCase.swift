public protocol CompetionUseCase {
    associatedtype Parameters
    associatedtype Success
    associatedtype Failure: Error
    
    func invoke(_ parameters: Parameters, completion: ((Result<Success, Failure>) -> Void)?)
    func cancel()
}

public final class AnyCompetionUseCase<Parameters, Success, Failure: Error>: CompetionUseCase {
    private let box: AnyCompetionUseCaseBox<Parameters, Success, Failure>

    public init<T: CompetionUseCase>(_ base: T) where T.Parameters == Parameters, T.Success == Success, T.Failure == Failure {
        self.box = CompetionUseCaseBox<T>(base)
    }

    public func invoke(_ parameters: Parameters, completion: ((Result<Success, Failure>) -> ())?) {
        box.invoke(parameters, completion: completion)
    }

    public func cancel() {
        box.cancel()
    }
}

private class AnyCompetionUseCaseBox<Parameters, Success, Failure: Error> {
    func invoke(_ parameters: Parameters, completion: ((Result<Success, Failure>) -> ())?) {
        fatalError()
    }

    func cancel() {
        fatalError()
    }
}

private final class CompetionUseCaseBox<T: CompetionUseCase>: AnyCompetionUseCaseBox<T.Parameters, T.Success, T.Failure> {
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func invoke(_ parameters: T.Parameters, completion: ((Result<T.Success, T.Failure>) -> ())?) {
        base.invoke(parameters, completion: completion)
    }

    override func cancel() {
        base.cancel()
    }
}
