//
//  DIContainer.swift
//
//
//  Created by Yuki Okudera on 2024/01/02.
//

import Foundation

public protocol DIContainer {
    func register<DependencyType>(type: DependencyType.Type, dependency: @escaping () -> DependencyType)
    func register<DependencyType>(key: String, dependency: @escaping () -> DependencyType)
    func resolve<DependencyType>(type: DependencyType.Type) -> DependencyType
    func resolve<DependencyType>(key: String) -> DependencyType
}

public class DependencyContainer {
    public static let shared: DIContainer = DependencyContainer()
    private var dependencyInitializer: [String: () -> Any] = [:]
}


extension DependencyContainer: DIContainer {
    public func register<DependencyType>(type: DependencyType.Type, dependency:  @escaping () -> DependencyType) {
        self.register(key: dependencyKey(for: type), dependency: dependency)
    }

    public func register<DependencyType>(key: String, dependency:  @escaping () -> DependencyType) {
        self.dependencyInitializer[key] = dependency
    }

    public func resolve<DependencyType>(type: DependencyType.Type) -> DependencyType {
        self.resolve(key: dependencyKey(for: type))
    }

    public func resolve<DependencyType>(key: String) -> DependencyType {
        guard let dependency = self.dependencyInitializer[key]?() as? DependencyType else {
            preconditionFailure("DependencyContainer.resolve. There is no dependency registered for this type. Please register a dependency for this type.")
        }
        return dependency
    }

    private func dependencyKey<DependencyType>(for type: DependencyType.Type) -> String {
        return String(describing: type)
    }
}

@propertyWrapper
public struct Inject<Value> {
    private(set) public var wrappedValue: Value

    public init(key: String? = nil) {
        if let key {
            self.wrappedValue = DependencyContainer.shared.resolve(key: key)
        } else {
            self.wrappedValue = DependencyContainer.shared.resolve(type: Value.self)
        }
    }
}
