//
//  Busier.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/13/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

enum Busier: Int {
    case quiet
    case moderate
    case busy
    case veryBusy
}

extension Busier {

    var valueForDisplay: String {
        switch self {
        case .quiet     : return "Quiet"
        case .moderate  : return "Moderate"
        case .busy      : return "Busy"
        case .veryBusy  : return "Very Busy"
        }
    }

    var pulsarRadius: CGFloat {
        switch self {
        case .quiet     : return 20
        case .moderate  : return 30
        case .busy      : return 40
        case .veryBusy  : return 50
        }
    }

    var pulsarColor: UIColor {
        switch self {
        case .quiet     : return .greenLime
        case .moderate  : return .yellowMustard
        case .busy      : return .orangeDeepSaffron
        case .veryBusy  : return .orangeSmashedPumpkin
        }
    }
}

extension Busier {

    init(fromRestaurantNameOnlyForTest name: String) {
        guard let firstCharacterASCII = name.lowercased().first?.asciiValue else {
            self = .quiet
            return
        }
        switch firstCharacterASCII {
        case 97...101: self = .quiet
        case 102...107: self = .moderate
        case 108...113: self = .busy
        case 114...122: self = .veryBusy
        default: self = .quiet
        }
    }
    
}
