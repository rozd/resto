//
//  LocatorService.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation
import Alamofire
import Promises

protocol LocatorService {
    func findRestaurants() -> Promise<[Restaurant]>
}

class GooglePlacesLocatorService: LocatorService {

    func findRestaurants() -> Promise<[Restaurant]> {
        return Promise<[Restaurant]> { fulfill, reject in
            AF.request("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyAC8r9awZVAn-KUNIt6EN3obU-j3LPCOgI")
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        guard let results = (json as AnyObject).value(forKey: "results") as? [[String: Any]] else {
                            reject(NSError(domain: "Resto.Serialization", code: 0, userInfo: [NSLocalizedDescriptionKey : "Can't retrieve `result` array from a response."]))
                            return
                        }
                        fulfill(.init(from: results))
                    case .failure(let error):
                        reject(error)
                    }
                }
        }
    }
}