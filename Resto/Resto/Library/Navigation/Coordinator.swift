//
//  Coordinator.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class BaseCoordinator<Value> {

    typealias Completion = (_ result: Value) -> ()

    // MARK: Manage child coordinators

    private var children: [UUID: Any] = [:]

    private let identifier = UUID()

    private func hold<T>(coordinator: BaseCoordinator<T>) {
        children[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: BaseCoordinator<T>) {
        children.removeValue(forKey: coordinator.identifier)
    }

    // MARK: API

    func coordinate<T>(to coordinator: BaseCoordinator<T>, with completion: @escaping (T) -> ()) {
        hold(coordinator: coordinator)

        coordinator.start { [weak self] value in
            completion(value)
            self?.free(coordinator: coordinator)
        }
    }

    func start(with completion: @escaping Completion) {
        fatalError("BaseCoordinator.start() method should be implemented in subclass.")
    }
    
}
