//
//  RestaurantAnnotationView.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class RestaurantAnnotationView: MKAnnotationView {

    struct Constants {
        static let viewSize         = CGSize(width: 12.0, height: 12.0)
        static let calloutOffset    = CGPoint(x: -6.0, y: 0.0)
    }

    // MARK Views

    fileprivate lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, busierViewStack])
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 10.0
        return stackView
    }()

    fileprivate lazy var imageView: UIImageView = {
        let view = UIImageView(image: nil)
        view.frame.size = CGSize(width: 240.0, height: 148.0)
        view.contentMode = .scaleAspectFill
        return view
    }()

    fileprivate lazy var busierViewStack: UIStackView = {
        let label = UILabel()
        label.text = "Busier:"
        label.font = .preferredFont(forTextStyle: .headline)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let stackView = UIStackView(arrangedSubviews: [label, busierLabel])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 4.0
        return stackView
    }()

    fileprivate lazy var busierLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    // MARK: Layers

    fileprivate lazy var pulsar: Pulsar = {
        let pulsar = Pulsar()
        pulsar.radiusOfPulse = 40.0
        pulsar.numberOfPulses = 2
        return pulsar
    }()

    fileprivate lazy var marker: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: Constants.viewSize)).cgPath
        layer.bounds = CGRect(origin: .zero, size: Constants.viewSize)
        layer.fillColor = UIColor.systemBlue.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 4.0
        layer.shadowColor = UIColor.systemBlue.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 8.0
        layer.shadowOffset = .zero
        return layer
    }()

    // MARK: Lifeycle

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds.size = Constants.viewSize
        self.setupCallout()
        self.layer.addSublayer(pulsar)
        self.layer.addSublayer(marker)
        pulsar.start()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Annotation lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
        busierLabel.text = nil
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        guard let annotation = annotation as? RestaurantAnnotation else {
            return
        }

        pulsar.radiusOfPulse = annotation.pulsarRadius
        pulsar.backgroundColor = annotation.pulsarColor.cgColor
        pulsar.start()

        imageView.kf.setImage(with: annotation.photoURL)

        busierLabel.text      = annotation.busier
        busierLabel.textColor = annotation.pulsarColor
    }

}


// MARK: Callout

extension RestaurantAnnotationView {

    func setupCallout() {

        canShowCallout = true
        calloutOffset = Constants.calloutOffset

        self.detailCalloutAccessoryView = stackView
    }

}
