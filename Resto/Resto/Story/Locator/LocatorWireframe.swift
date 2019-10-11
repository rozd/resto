//
//  LocatorWireframe.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

// MARK: Dependency Injection

protocol LocatorAssembler {

}

extension LocatorAssembler {

}

// MARK: Storyboard Integration

extension UIStoryboard {

    class var locator: UIStoryboard {
        return UIStoryboard(name: "Locator", bundle: nil)
    }

    func instantiateInitialViewController(with viewModel: LocatorViewModel) -> UIViewController? {
        guard let vc = UIStoryboard.locator.instantiateInitialViewController() as? LocatorViewController else {
            fatalError("Initial view controller for Locator storyboard should be of LocatorViewController type.")
        }
        vc.viewModel = viewModel
        return vc
    }
    
}
