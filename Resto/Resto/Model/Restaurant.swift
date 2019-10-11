//
//  Restaurant.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

struct Restaurant: Codable, Equatable {
    let name: String
    let latitude: Double
    let longitude: Double

    enum CodingKeys: String, CodingKey {
        case name
        case latitude   = "lat"
        case longitude  = "lng"
    }
}

// MARK: Manual Serialization

extension Restaurant {

    init?(from dict: [String: Any]) {
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
        self.name = dict[CodingKeys.name.rawValue] as? String ?? "Unknown"
    }

}

extension Array where Element == Restaurant {

    init(from dicts: [[String: Any]]) {
        self.init(dicts.map { Restaurant(from: $0) }.compactMap { $0 })
    }

}
