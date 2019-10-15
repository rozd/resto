//
//  Locator.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import Promises
import CoreLocation
import MapKit

class Locator {

    // MARK: Dependecies

    fileprivate let service: LocatorService

    // MARK: Model

    fileprivate var results: [(region: MKCircle, restaurants: [Restaurant])]

    // MARK: Lifecycle

    convenience init() {
        self.init(service: Context.assembler.resolve())
    }

    init(service: LocatorService) {
        self.service = service
        self.results = []
    }

    // MARK: Search for restaurants

    func findRestaurants(criteria: SearchCriteria) -> Promise<[RestaurantAnnotation]> {
        if let restaurants = findInResults(criteria: criteria) {
            return Promise(restaurants.map { RestaurantAnnotation(restaurant: $0) })
        }
        return service.findRestaurants(criteria: criteria)
            .then { [weak self] in self?.storeInResults(criteria: criteria, results: $0) }
            .then { $0.map { RestaurantAnnotation(restaurant: $0) }}
    }
    
}

// MARK:

extension Locator {

    fileprivate func storeInResults(criteria: SearchCriteria, results: [Restaurant]) {
        self.results.append((region: criteria.region, restaurants: results))
    }

    fileprivate func findInResults(criteria: SearchCriteria) -> [Restaurant]? {
        let region = criteria.region
        return self.results.first(where: { $0.region.boundingMapRect.contains(region.boundingMapRect) })?.restaurants
    }

}
