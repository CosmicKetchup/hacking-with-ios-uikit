//
//  ProximitySensor.swift
//  p22.detect-a-beacon
//
//  Created by Matt Brown on 1/20/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit
import CoreLocation

final class ProximitySensor: UIView, DistanceDelegate {
    
    private let sensorCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        [sensorCircle].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            sensorCircle.topAnchor.constraint(equalTo: topAnchor),
            sensorCircle.leadingAnchor.constraint(equalTo: leadingAnchor),
            sensorCircle.bottomAnchor.constraint(equalTo: bottomAnchor),
            sensorCircle.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sensorCircle.layer.cornerRadius = frame.width / 2
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            switch distance {
            case .immediate:
                self?.sensorCircle.transform = .identity
            default:
                self?.sensorCircle.transform = CGAffineTransform(scaleX: distance.indicatorScale, y: distance.indicatorScale)
            }
            self?.sensorCircle.backgroundColor = distance.indicatorColor
        }
    }
}

private extension CLProximity {
    var indicatorColor: UIColor? {
        switch self {
        case .immediate:
            return UIColor(hex: "21BE0D")
        case .near:
            return UIColor(hex: "F6F740")
        case .far:
            return UIColor(hex: "EC4E20")
        default:
            return .black
        }
    }
    
    var indicatorScale: CGFloat {
        switch self {
        case .immediate:
            return 1.0
        case .near:
            return 0.5
        case .far:
            return 0.25
        default:
            return 0.1
        }
    }
}
