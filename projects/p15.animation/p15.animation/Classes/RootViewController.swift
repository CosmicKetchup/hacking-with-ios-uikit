//
//  RootViewController.swift
//  p15.animation
//
//  Created by Matt Brown on 1/8/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private enum ViewMetrics {
        static let rootBackgroundColor = UIColor.white
        
        static let buttonBackgroundColor = UIColor.systemBlue
        static let buttonTextColor = UIColor.white
        static let buttonContentInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        static let buttonCornerRadius: CGFloat = 7.0
    }
    
    private var currentAnimationIteration = 0
    
    private let penguinView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "penguin"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let primaryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        button.backgroundColor = ViewMetrics.buttonBackgroundColor
        button.setTitle("Tap", for: .normal)
        button.setTitleColor(ViewMetrics.buttonTextColor, for: .normal)
        button.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        button.contentEdgeInsets = ViewMetrics.buttonContentInsets
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = ViewMetrics.rootBackgroundColor
        
        [penguinView, primaryButton].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            penguinView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            penguinView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            primaryButton.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: penguinView.bottomAnchor, multiplier: 1.0),
            primaryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: primaryButton.bottomAnchor, multiplier: 3.0),
        ])
    }
}

extension RootViewController {
    @objc fileprivate func buttonTapped(_ button: UIButton) {
        button.isHidden = true
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, animations: { [weak self] in
            switch self?.currentAnimationIteration {
            case 0:
                self?.penguinView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                
            case 2:
                self?.penguinView.transform = CGAffineTransform(translationX: -256, y: -256)
                
            case 4:
                self?.penguinView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                
            case 6:
                self?.penguinView.alpha = 0.1
                self?.penguinView.backgroundColor = .green
                
            case 7:
                self?.penguinView.alpha = 1.0
                self?.penguinView.backgroundColor = .clear
                
            case 1, 3, 5:
                self?.penguinView.transform = .identity
                
            default:
                break
            }
        }) { _ in
            button.isHidden = false
        }
        
        currentAnimationIteration += 1
        if currentAnimationIteration > 7 {
            currentAnimationIteration = 0
        }
    }
}

