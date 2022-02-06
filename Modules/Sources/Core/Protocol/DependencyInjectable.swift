public protocol DependencyInjectable {
    associatedtype Dependency
    func inject(_ dependency: Dependency)
}
