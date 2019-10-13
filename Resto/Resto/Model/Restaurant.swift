//
//  Restaurant.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

struct Restaurant: Equatable {
    let name: String
    let photoReference: String?
    let latitude: Double
    let longitude: Double

    let busier: Busier

    enum CodingKeys: String, CodingKey {
        case name
        case latitude   = "lat"
        case longitude  = "lng"
        case photoReference   = "photo_reference"
        case busier
    }
}

// MARK: Manual Serialization

extension Restaurant {

    init?(from dict: [String: Any]) {
        // coordinate

        guard let geometry = dict["geometry"] as? [String: AnyObject] else {
            return nil
        }

        guard let location = geometry["location"] as? [String: AnyObject] else {
            return nil
        }

        guard let lat = location[CodingKeys.latitude.rawValue] as? Double, let lon = location[CodingKeys.longitude.rawValue] as? Double else {
            return nil
        }

        self.latitude = lat
        self.longitude = lon

        // photo

        self.photoReference = (dict["photos"] as? [[String: AnyObject]])?.first?[CodingKeys.photoReference.rawValue] as? String

        // name

        self.name = dict[CodingKeys.name.rawValue] as? String ?? "Unknown"

        // busier

        self.busier = Busier(fromRestaurantNameOnlyForTest: self.name)
    }

}

extension Array where Element == Restaurant {

    init(from dicts: [[String: Any]]) {
        self.init(dicts.map { Restaurant(from: $0) }.compactMap { $0 })
    }

}
