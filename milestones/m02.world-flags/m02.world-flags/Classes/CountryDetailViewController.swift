//
//  CountryDetailViewController.swift
//  m02.world-flags
//
//  Created by Matt Brown on 12/7/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

class CountryDetailViewController: UIViewController {
    
    fileprivate enum ViewMetrics {
        static let backgroundColor = UIColor.lightGray
        static let sharedPhotoCompressionQuality: CGFloat = 0.8
        
        static let imageViewBorderColor = UIColor.darkGray.cgColor
        static let imageViewBorderWidth: CGFloat = 1.0
    }
    
    private let country: Country!
    
    private lazy var flagImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: country.rawValue)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        view.layer.borderColor = ViewMetrics.imageViewBorderColor
        view.layer.borderWidth = ViewMetrics.imageViewBorderWidth
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.hidesBarsOnTap ?? false
    }
    
    init(country: Country) {
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
        navigationItem.title = country.formalName
        navigationItem.largeTitleDisplayMode = .never
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped))
        navigationItem.rightBarButtonItem = shareButton
        
        [flagImageView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            flagImageView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            flagImageView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
            flagImageView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            flagImageView.heightAnchor.constraint(equalTo: flagImageView.widthAnchor, multiplier: 0.5),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}

extension CountryDetailViewController {
    @objc fileprivate func shareButtonTapped() {
        guard let flagImage = flagImageView.image?.jpegData(compressionQuality: CountryDetailViewController.ViewMetrics.sharedPhotoCompressionQuality) else { return }
        let alert = UIActivityViewController(activityItems: [country.formalName, flagImage], applicationActivities: [])
        navigationController?.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
}
