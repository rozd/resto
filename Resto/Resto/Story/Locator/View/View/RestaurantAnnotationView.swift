//
//  RestaurantAnnotationView.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import MapKit
import Pulsator

class RestaurantAnnotationView: MKAnnotationView {

    // MARK: Lifeycle

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds.size = CGSize(width: 12, height: 12)
        self.layer.addSublayer(createPoint())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Pulse

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        showPulsator()
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        hidePulsator()
    }

    fileprivate var pulsator: Pulsator? {
        didSet {
            if let pulsator = pulsator {
                self.layer.insertSublayer(pulsator, at: 0)
            }
        }
    }

    fileprivate func showPulsator() {
        guard self.pulsator == nil else {
            return
        }
        let pulsator = createPulsator()
        pulsator.start()
        self.pulsator = pulsator
    }

    fileprivate func hidePulsator() {
        self.pulsator?.removeFromSuperlayer()
        self.pulsator = nil
    }

    fileprivate func createPulsator() -> Pulsator {
        let pulsator = Pulsator()
        pulsator.numPulse = 3
        pulsator.radius = 48.0
        pulsator.backgroundColor = UIColor.systemPink.cgColor
        pulsator.repeatCount = .infinity
        return pulsator
    }

    fileprivate func createPoint() -> CAShapeLayer {
        let shape = CAShapeLayer()
        var rect = self.bounds
        rect.origin = CGPoint(x: -rect.width / 2, y: -rect.height / 2)
        shape.path = UIBezierPath(ovalIn: rect).cgPath
        shape.fillColor = UIColor.systemTeal.cgColor
        return shape
    }
}
