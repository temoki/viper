public protocol SyncUseCase {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error

    func invoke(_ input: Input) -> Result<Output, Failure>
}

public final class AnySyncUseCase<Input, Output, Failure: Error>: SyncUseCase {
    private let box: AnySyncUseCaseBox<Input, Output, Failure>

    public init<T: SyncUseCase>(_ base: T)
    where T.Input == Input, T.Output == Output, T.Failure == Failure {
        self.box = SyncUseCaseBox<T>(base)
    }

    public func invoke(_ input: Input) -> Result<Output, Failure> {
        box.invoke(input)
    }
}

private class AnySyncUseCaseBox<Input, Output, Failure: Error> {
    func invoke(_ input: Input) -> Result<Output, Failure> {
        fatalError()
    }
}

private final class SyncUseCaseBox<T: SyncUseCase>: AnySyncUseCaseBox<
    T.Input, T.Output, T.Failure
>
{
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func invoke(_ input: T.Input) -> Result<T.Output, T.Failure> {
        base.invoke(input)
    }
}
