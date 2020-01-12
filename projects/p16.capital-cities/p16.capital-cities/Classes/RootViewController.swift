//
//  RootViewController.swift
//  p16.capital-cities
//
//  Created by Matt Brown on 1/12/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import MapKit

final class RootViewController: UIViewController, MKMapViewDelegate {

    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.isPitchEnabled = false
        map.isRotateEnabled = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        navigationItem.title = "Project 16"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "map.fill"), style: .plain, target: self, action: #selector(editButtonTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: nil)
        
        mapView.delegate = self
        CapitalCity.allCases.forEach { mapView.addAnnotation($0.capital) }
        
        [mapView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Capital.reuseIdentifier) as? MKPinAnnotationView
        
        if annotationView != nil {
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Capital.reuseIdentifier)
            annotationView?.pinTintColor = .systemPurple
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital, let cityName = capital.title, let city = CapitalCity(rawValue: cityName) else { return }
        let browserView = BrowserViewController(for: city)
        navigationController?.pushViewController(browserView, animated: true)
    }
}

extension RootViewController {
    @objc fileprivate func editButtonTapped() {
        let alert = UIAlertController(title: "Choose Map Style", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] _ in self?.mapView.mapType = .standard })
        alert.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in self?.mapView.mapType = .satellite })
        alert.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in self?.mapView.mapType = .hybrid })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
}

