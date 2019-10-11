//
//  LocatorViewModel.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class LocatorViewModel {

    // MARK: Model

    fileprivate let locator: Locator

    // MARK: Outputs

    // MARK: Lifecycle

    init(locator: Locator) {
        self.locator = locator
    }

    // MARK: Actions

    func findRestaurants() {
        locator.findRestaurants()
    }
}
