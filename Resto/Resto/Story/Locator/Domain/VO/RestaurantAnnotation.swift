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

    var busier: String {
        return restaurant.busier.valueForDisplay
    }

    var pulsarColor: UIColor {
        return restaurant.busier.pulsarColor
    }

    var pulsarRadius: CGFloat {
        return restaurant.busier.pulsarRadius
    }

    var photoURL: URL? {
        guard let photoReference = restaurant.photoReference else {
            return nil
        }
        return URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=240&photoreference=\(photoReference)&key=\(Constants.apiKey)")
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
