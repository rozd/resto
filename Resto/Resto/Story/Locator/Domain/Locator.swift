//
//  Locator.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import Promises

class Locator {

    // MARK: Dependecies

    fileprivate let service: LocatorService

    // MARK: Lifecycle

    convenience init() {
        self.init(service: Context.assembler.resolve())
    }

    init(service: LocatorService) {
        self.service = service
    }

    // MARK: Search for restaurants

    func findRestaurants(criteria: SearchCriteria) -> Promise<[RestaurantAnnotation]> {
        return service.findRestaurants(criteria: criteria).then { $0.map { RestaurantAnnotation(restaurant: $0) }}
    }
    
}
