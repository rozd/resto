//
//  LocatorViewModel.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import Promises
import CoreLocation

class LocatorViewModel {

    // MARK: Model

    fileprivate let locator: Locator

    // MARK: Outputs

    // MARK: Lifecycle

    init(locator: Locator) {
        self.locator = locator
    }

    // MARK: Actions

    func findRestaurants(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) -> Promise<[RestaurantAnnotation]> {
        return locator.findRestaurants(criteria: SearchCriteria(coordinate: coordinate, radius: radius))
    }
}

// MARK: SearchCriteria Serialization

extension SearchCriteria {
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.radius = radius
    }
}

