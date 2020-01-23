//
//  ImageCell.swift
//  p25.selfie-share
//
//  Created by Matt Brown on 1/22/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class ImageCell: UICollectionViewCell, ReusableIdentifier {
    
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
        
        [imageView].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
}

extension ImageCell {
    func setImage(to image: UIImage?) {
        imageView.image = image
    }
}
