//
//  MainCoordinator.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class MainCoordinator: BaseCoordinator<()> {

    // MARK: Variables

    fileprivate let window: UIWindow

    fileprivate let viewModel: MainViewModel

    // MARK: Lifecycle

    init(window: UIWindow?, viewModel: MainViewModel) {
        guard let window = window else {
            fatalError("UIWindow is unavailable")
        }
        self.window = window
        self.viewModel  = viewModel
    }

    // MARK: Start point

    func start() {
        start {}
    }

    override func start(with completion: @escaping (()) -> ()) {
        showLocator { [weak self] in
            self?.start {}
        }
    }

}

// MARK: - Navigation

extension MainCoordinator {

    func showLocator(completion: @escaping () -> ()) {
        let coordinator = LocatorCoordinator(window: window, viewModel: viewModel.createLocatorViewModel())
        coordinate(to: coordinator, with: completion)
    }
    
}
