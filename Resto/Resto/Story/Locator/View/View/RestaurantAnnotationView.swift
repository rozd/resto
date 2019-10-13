//
//  RestaurantAnnotationView.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import MapKit

class RestaurantAnnotationView: MKAnnotationView {

    struct Constants {
        static let viewSize         = CGSize(width: 12.0, height: 12.0)
        static let calloutOffset    = CGPoint(x: -6.0, y: 0.0)
        static let pulsarColor      = UIColor(named: "blueCornflower") ?? UIColor.systemPurple
    }

    // MARK: Pulsar

    lazy var pulsar: Pulsar = {
        let pulsar = Pulsar()
        pulsar.radiusOfPulse = 40.0
        pulsar.numberOfPulses = 2
        pulsar.backgroundColor = Constants.pulsarColor.cgColor
        return pulsar
    }()

    lazy var marker: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: Constants.viewSize)).cgPath
        layer.bounds = CGRect(origin: .zero, size: Constants.viewSize)
        layer.fillColor = UIColor.systemBlue.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 4.0
        return layer
    }()

    // MARK: Lifeycle

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds.size = Constants.viewSize
        canShowCallout = true
        calloutOffset = Constants.calloutOffset
        self.layer.addSublayer(pulsar)
        self.layer.addSublayer(marker)
        pulsar.start()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
