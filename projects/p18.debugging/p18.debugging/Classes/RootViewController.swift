//
//  RootViewController.swift
//  p18.debugging
//
//  Created by Matt Brown on 1/12/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private enum ViewMetrics {
        static let backgroundColor = UIColor.white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = ViewMetrics.backgroundColor
        navigationItem.title = "Project 18"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        for i in 1...100 {
            print("Got number \(i)!")
        }
    }
}

