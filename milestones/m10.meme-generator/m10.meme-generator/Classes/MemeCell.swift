//
//  MemeCell.swift
//  m10.meme-generator
//
//  Created by Matt Brown on 1/24/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class MemeCell: UICollectionViewCell, ReusableIdentifier {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
        static let layoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        static let imageViewBorderWidth: CGFloat = 1.0
        static let imageViewBorderColor = UIColor.darkGray.cgColor
    }
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        view.layer.borderWidth = ViewMetrics.imageViewBorderWidth
        view.layer.borderColor = ViewMetrics.imageViewBorderColor
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor(white: 0, alpha: 0.4)
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
        directionalLayoutMargins = ViewMetrics.layoutMargins
        
        [imageView, titleLabel].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
}

extension MemeCell {
    func configure(for meme: Meme) {
        imageView.image = UIImage(named: meme.filename)
        titleLabel.text = meme.title
    }
}
