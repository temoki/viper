public protocol CompetionUseCase {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error
    
    func invoke(_ input: Input, completion: ((Result<Output, Failure>) -> Void)?)
    func cancel()
}

public final class AnyCompetionUseCase<Input, Output, Failure: Error>: CompetionUseCase {
    private let box: AnyCompetionUseCaseBox<Input, Output, Failure>

    public init<T: CompetionUseCase>(_ base: T) where T.Input == Input, T.Output == Output, T.Failure == Failure {
        self.box = CompetionUseCaseBox<T>(base)
    }

    public func invoke(_ input: Input, completion: ((Result<Output, Failure>) -> ())?) {
        box.invoke(input, completion: completion)
    }

    public func cancel() {
        box.cancel()
    }
}

private class AnyCompetionUseCaseBox<Input, Output, Failure: Error> {
    func invoke(_ input: Input, completion: ((Result<Output, Failure>) -> ())?) {
        fatalError()
    }

    func cancel() {
        fatalError()
    }
}

private final class CompetionUseCaseBox<T: CompetionUseCase>: AnyCompetionUseCaseBox<T.Input, T.Output, T.Failure> {
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func invoke(_ input: T.Input, completion: ((Result<T.Output, T.Failure>) -> ())?) {
        base.invoke(input, completion: completion)
    }

    override func cancel() {
        base.cancel()
    }
}
