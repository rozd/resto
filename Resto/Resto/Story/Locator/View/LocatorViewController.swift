//
//  LocatorViewController.swift
//  Resto
//
//  Created by Max Rozdobudko on 10/11/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Pulsator

class LocatorViewController: UIViewController {

    // MARK: Managers

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = .greatestFiniteMagnitude
        manager.pausesLocationUpdatesAutomatically = true
        return manager
    }()

    // MARK: Outlets

    @IBOutlet fileprivate weak var mapView: MKMapView!

    // MARK: View model

    var viewModel: LocatorViewModel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // mapView

        mapView.delegate = self

        // update data

        updateRestaurants()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        requestLocationIfNeeded()
        startUpdateLocationIfAllowed()
    }

}

// MARK: - Work with Restaurants

extension LocatorViewController {

    func updateRestaurants() {

        let coordinate = mapView.centerCoordinate
        let radius = mapView.region.largerRadiusInMeters

        viewModel.findRestaurants(coordinate: coordinate, radius: radius)
            .then { [weak self] annotations in
                self?.placeRestaurants(annotations: annotations)
            }.catch { [weak self] error in
                self?.showAlert(withError: error)
            }
    }

    func placeRestaurants(annotations: [RestaurantAnnotation]) {
        let presentedAnnotations = mapView.annotations.compactMap { $0 as? RestaurantAnnotation }

        let additinalAnnotations = annotations.filter { presentedAnnotations.firstIndex(of: $0) == nil }
        let redundantAnnotations = presentedAnnotations.filter { annotations.firstIndex(of: $0) == nil }

        mapView.removeAnnotations(redundantAnnotations)
        mapView.addAnnotations(additinalAnnotations)
    }
}

// MARK: - Map Placement

extension LocatorViewController {

    func map(centerAt location: CLLocation) {
        let coordinate = location.coordinate

        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)

        mapView.setRegion(region, animated: true)
    }

}

// MARK: - Work with Location

extension LocatorViewController {

    func startUpdateLocationIfAllowed(status: CLAuthorizationStatus? = nil) {
        let status = status ?? CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func requestLocationIfNeeded() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .restricted, .denied:
            showAlert(withTitle: "Location Service Disabled", message: "Please enable Location Service in Settings of \(Constants.appName) app")
        case .notDetermined:
            fallthrough
        @unknown default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension LocatorViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startUpdateLocationIfAllowed(status: status)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        map(centerAt: location)
    }

}

// MARK: - MKMapViewDelegate

extension LocatorViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateRestaurants()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RestaurantAnnotation else {
            return nil
        }

        if let marker = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.reuseIdentifier) {
            marker.clusteringIdentifier = annotation.clusteringIdentifer
            return marker
        }

        let marker = RestaurantAnnotationView(annotation: annotation, reuseIdentifier: annotation.reuseIdentifier)
        marker.clusteringIdentifier = annotation.clusteringIdentifer
        return marker
    }

}
