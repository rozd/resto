//
//  MainViewModel.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import Foundation

class MainViewModel {

    // MARK: Model

    // MARK: Lifecycle

    init() {

    }
}

// MARK: - Nested view models

extension MainViewModel {

    func createLocatorViewModel() -> LocatorViewModel {
        return LocatorViewModel()
    }
    
}
