public protocol AsyncUseCase {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error

    func invoke(_ input: Input) async -> Result<Output, Failure>
}

public final class AnyAsyncUseCase<Input, Output, Failure: Error>: AsyncUseCase {
    private let box: AnyAsyncUseCaseBox<Input, Output, Failure>

    public init<T: AsyncUseCase>(_ base: T)
    where T.Input == Input, T.Output == Output, T.Failure == Failure {
        self.box = AsyncUseCaseBox<T>(base)
    }

    public func invoke(_ input: Input) async -> Result<Output, Failure> {
        await box.invoke(input)
    }
}

private class AnyAsyncUseCaseBox<Input, Output, Failure: Error> {
    func invoke(_ input: Input) async -> Result<Output, Failure> {
        fatalError()
    }
}

private final class AsyncUseCaseBox<T: AsyncUseCase>: AnyAsyncUseCaseBox<
    T.Input, T.Output, T.Failure
>
{
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func invoke(_ input: T.Input) async -> Result<T.Output, T.Failure> {
        await base.invoke(input)
    }
}
