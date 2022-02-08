public protocol AsyncUseCase {
    associatedtype Parameters
    associatedtype Success
    associatedtype Failure: Error
    
    func invoke(_ parameters: Parameters) async -> Result<Success, Failure>
}

public final class AnyAsyncUseCase<Parameters, Success, Failure: Error>: AsyncUseCase {
    private let box: AnyAsyncUseCaseBox<Parameters, Success, Failure>

    public init<T: AsyncUseCase>(_ base: T) where T.Parameters == Parameters, T.Success == Success, T.Failure == Failure {
        self.box = AsyncUseCaseBox<T>(base)
    }

    public func invoke(_ parameters: Parameters) async -> Result<Success, Failure> {
        await box.invoke(parameters)
    }
}

private class AnyAsyncUseCaseBox<Parameters, Success, Failure: Error> {
    func invoke(_ parameters: Parameters) async -> Result<Success, Failure> {
        fatalError()
    }
}

private final class AsyncUseCaseBox<T: AsyncUseCase>: AnyAsyncUseCaseBox<T.Parameters, T.Success, T.Failure> {
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func invoke(_ parameters: T.Parameters) async -> Result<T.Success, T.Failure> {
        await base.invoke(parameters)
    }
}
