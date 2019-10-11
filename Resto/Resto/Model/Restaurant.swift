//
//  Restaurant.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

struct Restaurant: Codable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: Manual Serialization

extension Restaurant {

    init?(from dict: [String: Any]) {
        self.name = dict[CodingKeys.name.rawValue] as? String ?? "Unknown"
    }

}

extension
