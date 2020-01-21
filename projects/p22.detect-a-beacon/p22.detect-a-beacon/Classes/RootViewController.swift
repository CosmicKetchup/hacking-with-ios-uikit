//
//  RootViewController.swift
//  p22.detect-a-beacon
//
//  Created by Matt Brown on 1/19/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import CoreLocation

protocol DistanceDelegate {
    func update(distance: CLProximity)
}

final class RootViewController: UIViewController, CLLocationManagerDelegate {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor(white: 0.85, alpha: 1.0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private let defaults = UserDefaults.standard
    private let beaconDataKey = "savedBeacons"
    
    private var distanceDelegate: DistanceDelegate!
    private var locationManager: CLLocationManager?
    private var availableBeaconIds = [Int: String]()
    private var knownBeacons = [UUID]()
    
    private var selectedBeacon: String? {
        didSet {
            guard let beaconId = selectedBeacon else { return }
            registerAndScan(for: beaconId)
        }
    }
    
    private let projectNumberLabel = UILabel(text: "PROJECT 22", style: .caption1)
    private let projectNameLabel = UILabel(text: "Detect-a-Beacon", style: .largeTitle)
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [projectNumberLabel, projectNameLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2.0
        return stack
    }()
    
    private let button01 = BeaconButton(text: "01", tag: 1)
    private let button02 = BeaconButton(text: "02", tag: 2)
    private let button03 = BeaconButton(text: "03", tag: 3)
    private lazy var beaconButtons = [button01, button02, button03]
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: beaconButtons)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 25.0
        return stack
    }()
    
    private let proximitySensor = ProximitySensor()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAvailableBeacons()
        loadData()
        setupView()
    }

    private func setupView() {
        navigationItem.title = "Project 22"
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = ViewMetrics.backgroundColor
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        distanceDelegate = proximitySensor
        
        let proximitySensorCenterYAnchorConstraint = proximitySensor.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        proximitySensorCenterYAnchorConstraint.priority = .defaultLow
        
        [labelStack, buttonStack, proximitySensor].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            labelStack.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 3.0),
            labelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonStack.topAnchor.constraint(equalToSystemSpacingBelow: labelStack.bottomAnchor, multiplier: 3.0),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            proximitySensor.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            proximitySensor.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: buttonStack.bottomAnchor, multiplier: 5.0),
            proximitySensor.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.75),
            proximitySensor.heightAnchor.constraint(equalTo: proximitySensor.widthAnchor, multiplier: 1.0),
            proximitySensorCenterYAnchorConstraint
        ])
        
        beaconButtons.forEach { $0.addTarget(self, action: #selector(beaconButtonPressed(_:)), for: .touchUpInside)}
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self), CLLocationManager.isRangingAvailable() else { return }
        default:
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            distanceDelegate.update(distance: beacon.proximity)
            
            if !knownBeacons.contains(beacon.uuid) {
                knownBeacons.append(beacon.uuid)
                saveData()
                displayNewBeaconAlert(for: beacon)
            }
        }
        else {
            distanceDelegate.update(distance: .unknown)
        }
    }
}

extension RootViewController {
    fileprivate func displayNewBeaconAlert(for beacon: CLBeacon) {
        let alert = UIAlertController(title: "New Beacon Detected", message: beacon.uuid.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc fileprivate func beaconButtonPressed(_ button: UIButton) {
        locationManager?.monitoredRegions.forEach { locationManager?.stopMonitoring(for: $0) }
        locationManager?.rangedBeaconConstraints.forEach { locationManager?.stopRangingBeacons(satisfying: $0) }
        
        beaconButtons.forEach { $0 !== button ? $0.deactivate() : $0.activate() }
        selectedBeacon = availableBeaconIds[button.tag]
    }
    
    private func registerAndScan(for beaconId: String) {
        guard let uuid = UUID(uuidString: beaconId) else { return }
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: beaconId)
        let beaconRange = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        startScanning(region: beaconRegion, range: beaconRange)
    }
    
    fileprivate func startScanning(region: CLBeaconRegion, range: CLBeaconIdentityConstraint) {
        locationManager?.startMonitoring(for: region)
        locationManager?.startRangingBeacons(satisfying: range)
    }
    
}

// MARK: - Data Management
extension RootViewController {
    fileprivate func loadAvailableBeacons() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let filePath = Bundle.main.url(forResource: "beacons", withExtension: "txt"), let rawData = try? String(contentsOf: filePath) {
                rawData
                    .components(separatedBy: "\n")
                    .enumerated()
                    .forEach { (index, str) in
                        guard !str.isEmpty else { return }
                        self?.availableBeaconIds[index + 1] = str }
            }
        }
    }
    
    fileprivate func saveData() {
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: knownBeacons, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: beaconDataKey)
        }
    }
    
    fileprivate func loadData() {
        if let savedData = defaults.object(forKey: beaconDataKey) as? Data {
            knownBeacons = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [UUID] ?? []
        }
    }
}

private extension UILabel {
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 1
        isUserInteractionEnabled = false
        
        font = .preferredFont(forTextStyle: style)
        adjustsFontForContentSizeCategory = true
        self.text = text
        textColor = .black
        textAlignment = .center
    }
}
