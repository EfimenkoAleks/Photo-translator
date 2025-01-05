//
//  Locator.swift
//  Photo translator
//
//  Created by Aleksandr on 12.12.2024.
//

import Foundation

protocol ServiceLocating {
    func resolve<T>() -> T?
}

final class ServiceLocator: ServiceLocating {

    static let shared = ServiceLocator() // Singleton

    // MARK: Private properties

    private lazy var services = [String: Any]()

    // MARK: Init
  
    private init() {}

    // MARK: Private methods

    private func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }

    // MARK: Internal methods

    func register<T>(service: T) {
        let key = typeName(T.self)
        services[key] = service
    }

    func resolve<T>() -> T? {
        let key = typeName(T.self)
        return services[key] as? T
    }
}

// используем

//ServiceLocator.shared.register(service: service)
//…
//func someMethod() {
//    guard let service: TestServiceProtocol = ServiceLocator.shared.resolve() else {
//        return
//    }
//    // используем service
//}
