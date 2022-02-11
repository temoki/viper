public protocol CallbackUseCase {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error

    func invoke(_ input: Input, callback: @escaping ((Result<Output, Failure>) -> Void))
    func cancel()
}

public final class AnyCallbackUseCase<Input, Output, Failure: Error>: CallbackUseCase {
    private let box: AnyCallbackUseCaseBox<Input, Output, Failure>

    public init<T: CallbackUseCase>(_ base: T)
    where T.Input == Input, T.Output == Output, T.Failure == Failure {
        self.box = CallbackUseCaseBox<T>(base)
    }

    public func invoke(_ input: Input, callback: @escaping ((Result<Output, Failure>) -> Void)) {
        box.invoke(input, callback: callback)
    }

    public func cancel() {
        box.cancel()
    }
}

private class AnyCallbackUseCaseBox<Input, Output, Failure: Error> {
    func invoke(_ input: Input, callback: @escaping (Result<Output, Failure>) -> Void) {
        fatalError()
    }

    func cancel() {
        fatalError()
    }
}

private final class CallbackUseCaseBox<T: CallbackUseCase>: AnyCallbackUseCaseBox<
    T.Input, T.Output, T.Failure
>
{
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func invoke(
        _ input: T.Input, callback: @escaping (Result<T.Output, T.Failure>) -> Void
    ) {
        base.invoke(input, callback: callback)
    }

    override func cancel() {
        base.cancel()
    }
}
