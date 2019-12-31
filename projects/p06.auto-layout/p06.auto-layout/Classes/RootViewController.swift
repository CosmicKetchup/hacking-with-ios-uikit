//
//  RootViewController.swift
//  p06.auto-layout
//
//  Created by Matt Brown on 10/9/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private enum ViewMetrics {
        static let labelHeight: CGFloat = 88.0
        static let labelSpacing: CGFloat = 10.0
    }
    
    private let label1 = UILabel(color: .red, text: "THESE")
    private let label2 = UILabel(color: .cyan, text: "ARE")
    private let label3 = UILabel(color: .yellow, text: "SOME")
    private let label4 = UILabel(color: .green, text: "AWESOME")
    private let label5 = UILabel(color: .orange, text: "LABELS")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // setupViewUsingVFL()
        setupView()
    }

    private func setupViewUsingVFL() {
        [label1, label2, label3, label4, label5].forEach({ view.addSubview($0) })
        let viewDict = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        let viewMetrics = ["labelHeight": 88]
        
        viewDict.keys.forEach { view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[\($0)]|", options: [], metrics: nil, views: viewDict)) }
        
        view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: viewMetrics, views: viewDict) )
    }
    
    private func setupView() {
        var previous: UILabel?
        [label1, label2, label3, label4, label5].forEach({ label in
            view.addSubview(label)
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            
            if let previousLabel = previous {
                label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: ViewMetrics.labelSpacing).isActive = true
            }
            else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            }
            
            previous = label
        })
    }

}

private extension UILabel {
    convenience init(color bgColor: UIColor, text labelText: String) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = bgColor
        text = labelText
        sizeToFit()
    }
}

