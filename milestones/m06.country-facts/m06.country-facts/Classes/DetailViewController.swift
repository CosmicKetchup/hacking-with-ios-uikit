//
//  DetailViewController.swift
//  m06.country-facts
//
//  Created by Matt Brown on 1/8/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
        static let flagBorderColor = UIColor.lightGray.cgColor
        static let flagBorderWidth: CGFloat = 1.0
        static let detailStackSpacing = UIStackView.spacingUseSystem
    }
    
    private let country: Country!
    
    private lazy var officialName = DetailField(type: .officialName, info: country.officialName)
    private lazy var capital = DetailField(type: .capital, info: country.capital)
    private lazy var region = DetailField(type: .region, info: country.region)
    private lazy var subregion = DetailField(type: .subregion, info: country.subregion)
    private lazy var latitude = DetailField(type: .latitude, info: country.latitude)
    private lazy var longitude = DetailField(type: .longitude, info: country.longitude)
    private lazy var area = DetailField(type: .area, info: country.totalArea)
    private lazy var domain = DetailField(type: .tld, info: country.tld)
    
    private lazy var detailStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [officialName, capital, region, subregion, latitude, longitude, area, domain])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = ViewMetrics.detailStackSpacing
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let subview = UIScrollView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        return subview
    }()
    
    init(for country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = ViewMetrics.backgroundColor
        navigationItem.title = country.commonName
        navigationItem.largeTitleDisplayMode = .never
        
        scrollView.addSubview(detailStack)
        [scrollView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            detailStack.topAnchor.constraint(equalToSystemSpacingBelow: scrollView.contentLayoutGuide.topAnchor, multiplier: 3.0),
            detailStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            detailStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            detailStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
}
