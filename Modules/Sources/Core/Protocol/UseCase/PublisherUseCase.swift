import Combine

public protocol PublisherUseCase {
    associatedtype Input
    associatedtype Output
    associatedtype Failure: Error

    func invoke(_ input: Input) -> AnyPublisher<Output, Failure>
}

public final class AnyPublisherUseCase<Input, Output, Failure: Error>: PublisherUseCase {
    private let box: AnyPublisherUseCaseBox<Input, Output, Failure>

    public init<T: PublisherUseCase>(_ base: T)
    where T.Input == Input, T.Output == Output, T.Failure == Failure {
        self.box = PublisherUseCaseBox<T>(base)
    }

    public func invoke(_ input: Input) -> AnyPublisher<Output, Failure> {
        box.invoke(input)
    }
}

private class AnyPublisherUseCaseBox<Input, Output, Failure: Error> {
    func invoke(_ input: Input) -> AnyPublisher<Output, Failure> {
        fatalError()
    }
}

private final class PublisherUseCaseBox<T: PublisherUseCase>: AnyPublisherUseCaseBox<
    T.Input, T.Output, T.Failure
>
{
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func invoke(_ input: T.Input) -> AnyPublisher<T.Output, T.Failure> {
        base.invoke(input)
    }
}
