//
//  ExtensionViewController.swift
//  p19.javascript-injection
//
//  Created by Matt Brown on 1/16/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class ExtensionViewController: UIViewController {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.lightGray
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Hello, world!"
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = ViewMetrics.backgroundColor
        
        [label].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

