//
//  LocatorCoordinator.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class LocatorCoordinator: BaseCoordinator<()> {

    // MARK: Properties

    fileprivate let window: UIWindow

    fileprivate let viewModel: LocatorViewModel

    // MARK: Lifecycle

    init(window: UIWindow, viewModel: LocatorViewModel) {
        self.window = window
        self.viewModel = viewModel
    }

    // MARK: Entry point

    override func start(with completion: @escaping (()) -> ()) {
        let rootViewController = UIStoryboard.locator.instantiateInitialViewController(with: viewModel)
        window.rootViewController = rootViewController
    }
    
}
