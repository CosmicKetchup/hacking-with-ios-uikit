//
//  DetailField.swift
//  m06.country-facts
//
//  Created by Matt Brown on 1/10/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

enum DetailFieldType: String {
    case officialName = "Official Name"
    case capital = "Capital"
    case area = "Area"
    case tld = "Web Domain"
    case region = "Region"
    case subregion = "Subregion"
    case latitude = "Latitude"
    case longitude = "Longitude"
}

final class DetailField: UIView {
    
    private enum ViewMetrics {
        static let titleFont = UIFont.boldSystemFont(ofSize: 18.0)
        static let detailFont = UIFont.systemFont(ofSize: 18.0)
        static let textColor = UIColor.black
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.isUserInteractionEnabled = false
        label.numberOfLines = 0
        
        label.font = ViewMetrics.titleFont
        label.textAlignment = .right
        label.textColor = ViewMetrics.textColor
        
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        label.font = ViewMetrics.detailFont
        label.textAlignment = .left
        label.textColor = ViewMetrics.textColor
        
        return label
    }()
    
    init(type: DetailFieldType, info: String) {
        titleLabel.text = type.rawValue
        detailLabel.text = info.isEmpty ? "N/A" : info        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, detailLabel].forEach { self.addSubview($0) }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            
            titleLabel.firstBaselineAnchor.constraint(equalTo: detailLabel.firstBaselineAnchor),
            
            detailLabel.topAnchor.constraint(equalTo: topAnchor),
            detailLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 2.0),
            bottomAnchor.constraint(greaterThanOrEqualTo: detailLabel.bottomAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
