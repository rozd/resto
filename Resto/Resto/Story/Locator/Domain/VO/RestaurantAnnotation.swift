//
//  RestaurantAnnotation.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {

    fileprivate let restaurant: Restaurant

    // MARK: Annotation

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
    }

    var title: String? {
        return restaurant.name
    }

    var subtitle: String? {
        return nil
    }

    // MARK: Lifecycle

    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init()
    }
}

extension RestaurantAnnotation {

    var reuseIdentifier: String {
        return "RestaurantAnnotation"
    }

    var clusteringIdentifer: String {
        return "restaurant"
    }
    
}
