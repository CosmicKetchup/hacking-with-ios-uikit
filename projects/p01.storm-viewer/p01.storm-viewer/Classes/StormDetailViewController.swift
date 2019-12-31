//
//  StormDetailViewController.swift
//  p01.storm-viewer
//
//  Created by Matt Brown on 10/4/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

class StormDetailViewController: UIViewController {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.lightGray
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        navigationController?.hidesBarsOnTap ?? false
    }
    
    private var selectedStorm: String
    private var fileIndex: Int
    private var totalCount: Int
    
    private lazy var stormView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: selectedStorm)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    init(file stormFilename: String, metrics: (Int, Int)) {
        self.selectedStorm = stormFilename
        (self.fileIndex, self.totalCount) = metrics
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
        navigationItem.title = "Picture \(fileIndex) of \(totalCount)"
        navigationItem.largeTitleDisplayMode = .never
        
        [stormView].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            stormView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stormView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stormView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            stormView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
