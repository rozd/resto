//
//  SearchCriteria+MapKit.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/15/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import MapKit

extension SearchCriteria {

    var center: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var region: MKCircle {
        return MKCircle(center: center, radius: radius)
    }
    
}

