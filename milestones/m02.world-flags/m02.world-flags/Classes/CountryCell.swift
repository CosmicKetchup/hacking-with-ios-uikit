//
//  CountryCell.swift
//  m02.world-flags
//
//  Created by Matt Brown on 12/23/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit


final class CountryCell: UITableViewCell, ReusableIdentifier {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
        static let cellMargins = NSDirectionalEdgeInsets(top: 8.0, leading: 16.0, bottom: 8.0, trailing: 16.0)

        static let imageViewHeight: CGFloat = 32.0
        static let imageViewBorderColor = UIColor.lightGray.cgColor
        static let imageViewBorderWidth: CGFloat = 1.0
        static let imageViewCornerRadius: CGFloat = 5.0
        
        static let labelFont = UIFont.preferredFont(forTextStyle: .title3)
    }
    
    private let country: Country!
    
    private let flagImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        view.layer.borderColor = ViewMetrics.imageViewBorderColor
        view.layer.borderWidth = ViewMetrics.imageViewBorderWidth
        view.layer.cornerRadius = ViewMetrics.imageViewCornerRadius
        return view
    }()
    
    private let countryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .natural
        label.font = ViewMetrics.labelFont
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        label.textColor = .black
        return label
    }()
    
    init(_ country: Country) {
        self.country = country
        super.init(style: .default, reuseIdentifier: CountryCell.reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = ViewMetrics.backgroundColor
        directionalLayoutMargins = ViewMetrics.cellMargins
        accessoryType = .disclosureIndicator
        
        flagImageView.image = UIImage(named: country.rawValue)
        countryLabel.text = country.formalName
        
        [flagImageView, countryLabel].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: layoutMarginsGuide.topAnchor, multiplier: 1.0),
            flagImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: layoutMarginsGuide.leadingAnchor, multiplier: 1.0),
            layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: flagImageView.bottomAnchor, multiplier: 1.0),
            flagImageView.heightAnchor.constraint(equalToConstant: ViewMetrics.imageViewHeight),
            flagImageView.widthAnchor.constraint(equalTo: flagImageView.heightAnchor, multiplier: 2.0),
            
            flagImageView.centerYAnchor.constraint(equalTo: countryLabel.centerYAnchor),
            
            countryLabel.topAnchor.constraint(equalToSystemSpacingBelow: layoutMarginsGuide.topAnchor, multiplier: 1.0),
            countryLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: flagImageView.trailingAnchor, multiplier: 1.0),
            layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: countryLabel.bottomAnchor, multiplier: 1.0),
            layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: countryLabel.trailingAnchor, multiplier: 1.0),
        ])
    }
}
