//
//  FlagViewController.swift
//  p02.guess-the-flag
//
//  Created by Matt Brown on 10/5/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class FlagViewController: UIViewController {
    
    fileprivate enum ViewMetrics {
        static let backgroundColor = UIColor.white
        static let navItemTintColor = UIColor.black
        static let rootMargins = NSDirectionalEdgeInsets(top: 36.0, leading: 16.0, bottom: 20.0, trailing: 16.0)
        
        // Flag UIImageViews & Stack
        static let flagBackgroundColor = UIColor.red
        static let flagBorderColor = UIColor.darkGray.cgColor
        static let flagBorderWidth: CGFloat = 1.0
        static let flagCornerRadius: CGFloat = 3.0
        static let flagSpacing: CGFloat = 30.0
    }
    
    private var isInitialSetupDone = false
    private var presentedCountries: [Country]!
    private var correctAnswerTag: Int!
    private var totalQuestions = 0
    
    private var userScore = 0 {
        didSet {
            navigationItem.rightBarButtonItem?.title = "Score: \(userScore)"
        }
    }
    
    private let topFlag = UIButton(tag: 0)
    private let midFlag = UIButton(tag: 1)
    private let botFlag = UIButton(tag: 2)
    
    private lazy var flagStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [topFlag, midFlag, botFlag])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = ViewMetrics.flagSpacing
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        newFlagQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustStackView(for: traitCollection)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection != previousTraitCollection {
            adjustStackView(for: traitCollection)
        }
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score: 0", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = ViewMetrics.navItemTintColor
        navigationController?.navigationBar.isUserInteractionEnabled = false
        view.backgroundColor = ViewMetrics.backgroundColor
        view.directionalLayoutMargins = ViewMetrics.rootMargins
        
        [topFlag, midFlag, botFlag].forEach { $0.addTarget(self, action: #selector(FlagViewController.flagTapped(_:)), for: .touchUpInside) }
        [flagStack].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            flagStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            view.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: flagStack.trailingAnchor),
            flagStack.topAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.topAnchor),
            view.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualTo: flagStack.bottomAnchor),
            flagStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            flagStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension FlagViewController {
    fileprivate func adjustStackView(for traitCollection: UITraitCollection) {
        flagStack.axis = traitCollection.verticalSizeClass == .compact ? .horizontal : .vertical
    }
    
    @objc fileprivate func flagTapped(_ sender: UIButton) {
        var alert: UIAlertController!
        
        if sender.tag == correctAnswerTag {
            userScore += 1
            alert = AlertType.correctAnswer(score: userScore).alert
        }
        else {
            userScore -= 1
            let userAnswer = presentedCountries[sender.tag]
            alert = AlertType.wrongAnswer(selectedCountry: userAnswer).alert
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.totalQuestions < 10 ? self.newFlagQuestion() : self.showGameOverAlert()
        })
        present(alert, animated: true)
    }
    
    fileprivate func newFlagQuestion() {
        totalQuestions += 1
        presentedCountries = Country.allCases.shuffled()
        [topFlag, midFlag, botFlag].enumerated().forEach { (index, button) in
            let targetFlag = UIImage(named: presentedCountries[index].rawValue)
            button.setImage(targetFlag, for: .normal)
        }
        
        correctAnswerTag = (0...2).randomElement()
        navigationItem.title = presentedCountries[correctAnswerTag].formalName.uppercased()
    }
    
    private func showGameOverAlert() {
        let alert = AlertType.gameOver(score: userScore).alert
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            self?.totalQuestions = 0
            self?.userScore = 0
            self?.newFlagQuestion()
        })
        present(alert, animated: true)
    }
}

private extension UIButton {
    convenience init(tag: Int) {
        self.init()
        self.tag = tag
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = FlagViewController.ViewMetrics.flagBackgroundColor
        contentMode = .scaleAspectFit
        
        layer.borderColor = FlagViewController.ViewMetrics.flagBorderColor
        layer.borderWidth = FlagViewController.ViewMetrics.flagBorderWidth
        layer.cornerRadius = FlagViewController.ViewMetrics.flagCornerRadius
    }
}

