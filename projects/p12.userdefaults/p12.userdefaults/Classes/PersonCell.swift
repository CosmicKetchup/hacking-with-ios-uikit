//
//  PersonCell.swift
//  p12.userdefaults
//
//  Created by Matt Brown on 12/8/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class PersonCell: UICollectionViewCell, ReusableIdentifier {
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
        
        static let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        static let cellHeight: CGFloat = 120.0
        static let cellTextColor = UIColor.black
        static let cellBorderColor = UIColor(white: 0.0, alpha: 0.3).cgColor
        static let cellBorderWidth: CGFloat = 2.0
        static let cellCornerRadius: CGFloat = 7.0
        
        static let personImageCornerRadius: CGFloat = 3.0
        
        static let nameLabelHeight: CGFloat = 40.0
        static let nameLabelFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    private let personImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = ViewMetrics.personImageCornerRadius
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.isUserInteractionEnabled = false
        label.font = ViewMetrics.nameLabelFont
        label.textAlignment = .center
        label.textColor = ViewMetrics.cellTextColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = ViewMetrics.backgroundColor
        layoutMargins = ViewMetrics.cellInsets
        
        layer.borderColor = ViewMetrics.cellBorderColor
        layer.borderWidth = ViewMetrics.cellBorderWidth
        layer.cornerRadius = ViewMetrics.cellCornerRadius
        
        [personImage, nameLabel].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            personImage.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            personImage.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            personImage.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor),
            personImage.heightAnchor.constraint(equalToConstant: ViewMetrics.cellHeight),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: personImage.bottomAnchor, multiplier: 1.0),
            nameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: nameLabel.bottomAnchor),
        ])
    }
    
    func configureFor(name: String, imagePath: URL) {
        nameLabel.text = name
        personImage.image = UIImage(contentsOfFile: imagePath.path)
        layoutIfNeeded()
    }
}
