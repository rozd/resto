//
//  LocatorService.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import Alamofire

protocol LocatorService {
    func findRestaurants()
}

class GooglePlacesLocatorService: LocatorService {

    func findRestaurants() {
        AF.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyAC8r9awZVAn-KUNIt6EN3obU-j3LPCOgI")
            .responseJSON { response in
                switch response.result {
                case .success(let json):
                    print(json)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
