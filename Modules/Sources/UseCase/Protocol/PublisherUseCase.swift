import Combine

public protocol PublisherUseCase {
    associatedtype Parameters
    associatedtype Success
    associatedtype Failure: Error
    
    func invoke(_ parameters: Parameters) -> AnyPublisher<Success, Failure>
}

public final class AnyPublisherUseCase<Parameters, Success, Failure: Error>: PublisherUseCase {
    private let box: AnyPublisherUseCaseBox<Parameters, Success, Failure>

    public init<T: PublisherUseCase>(_ base: T) where T.Parameters == Parameters, T.Success == Success, T.Failure == Failure {
        self.box = PublisherUseCaseBox<T>(base)
    }

    public func invoke(_ parameters: Parameters) -> AnyPublisher<Success, Failure> {
        box.invoke(parameters)
    }
}

private class AnyPublisherUseCaseBox<Parameters, Success, Failure: Error> {
    func invoke(_ parameters: Parameters) -> AnyPublisher<Success, Failure> {
        fatalError()
    }
}

private final class PublisherUseCaseBox<T: PublisherUseCase>: AnyPublisherUseCaseBox<T.Parameters, T.Success, T.Failure> {
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func invoke(_ parameters: T.Parameters) -> AnyPublisher<T.Success, T.Failure> {
        base.invoke(parameters)
    }
}
