//
//  MapKit+Helpers.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import MapKit

extension MKCoordinateRegion {

    var largerRadiusInMeters: CLLocationDistance {
        let furthestLocation = CLLocation(latitude: center.latitude + (span.latitudeDelta / 2),
                                          longitude: center.longitude + (span.longitudeDelta / 2))

        let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)

        return centerLocation.distance(from: furthestLocation)
    }

    var largerRadiusInKilometers: CLLocationDistance {
        return largerRadiusInMeters / 1000
    }
}
