//
//  UIKit+Alert.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(withTitle title: String?, message: String?) {
        showAlert(withTitle: title, message: message, handler: nil)
    }

    func showAlert(withTitle title: String?, message: String?, handler: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func showAlert(withError error: Error, handler: ((UIAlertAction) -> ())? = nil) {
        showAlert(withTitle: "Error", message: error.localizedDescription, handler: handler)
    }

}
