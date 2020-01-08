//
//  RootViewController.swift
//  p08.7-swifty-words
//
//  Created by Matt Brown on 10/22/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    fileprivate enum ViewMetrics {
        static let rootBackgroundColor = UIColor.white
        
        static let headerLabelsFontSize: CGFloat = 24.0
        static let answerLabelWidthMultiplier: CGFloat = 0.35
        static let clueLabelWidthMultiplier: CGFloat = 0.60
        
        static let textFieldFontSize: CGFloat = 44.0
        static let textFieldWidthMultiplier: CGFloat = 0.5
        static let answerButtonsInsets = UIEdgeInsets(top: 8.0, left: 20.0, bottom: 8.0, right: 20.0)
        static let answerButtonsCornerRadius: CGFloat = 5.0
        static let answerButtonsStackSpacing: CGFloat = 50.0
        
        static let buttonMapWidth: CGFloat = 750
        static let buttonMapHeight: CGFloat = 320
        static let buttonMapButtonWidth = 150
        static let buttonMapButtonHeight = 80
        static let buttonMapButtonFontSize: CGFloat = 36.0
        static let buttonMapButtonCornerRadius: CGFloat = 5.0
        static let buttonMapButtonInsets = UIEdgeInsets(top: 8.0, left: 20.0, bottom: 8.0, right: 20.0)
    }
    
    private var level = 1
    private var correctAnswers = 0
    private var userScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(userScore)"
        }
    }
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Score: 0"
        return label
    }()
    
    private let answerLabel = UILabel(alignment: .right)
    private let clueLabel = UILabel(alignment: .left)
    
    private let answerTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isUserInteractionEnabled = false
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: ViewMetrics.textFieldFontSize)
        textField.placeholder = "Tap letters to guess"
        return textField
    }()
    
    private let submitButton = UIButton(title: "SUBMIT")
    private let clearButton = UIButton(title: "CLEAR")
    
    private lazy var answerButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [submitButton, clearButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.spacing = ViewMetrics.answerButtonsStackSpacing
        return stack
    }()
    
    private var buttonMapButtons = [UIButton]()
    private var activatedButtons = [UIButton]()
    private let buttonMap: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    
    private var solutions = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadLevel()
    }

    private func setupView() {
        view.backgroundColor = ViewMetrics.rootBackgroundColor
        
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        [scoreLabel, answerLabel, clueLabel, answerTextField, answerButtonsStack, buttonMap].forEach({ view.addSubview($0) })
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.layoutMarginsGuide.topAnchor, multiplier: 1.0),
            scoreLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.layoutMarginsGuide.leadingAnchor, multiplier: 1.0),
            
            answerLabel.topAnchor.constraint(equalToSystemSpacingBelow: scoreLabel.bottomAnchor, multiplier: 1.0),
            answerLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: ViewMetrics.answerLabelWidthMultiplier),
            
            clueLabel.topAnchor.constraint(equalTo: answerLabel.topAnchor),
            clueLabel.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: answerLabel.trailingAnchor, multiplier: 1.0),
            clueLabel.bottomAnchor.constraint(equalTo: answerLabel.bottomAnchor),
            clueLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            clueLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: ViewMetrics.clueLabelWidthMultiplier),
            
            answerTextField.topAnchor.constraint(equalToSystemSpacingBelow: answerLabel.bottomAnchor, multiplier: 1.0),
            answerTextField.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            answerTextField.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: ViewMetrics.textFieldWidthMultiplier),
            
            answerButtonsStack.topAnchor.constraint(equalToSystemSpacingBelow: answerTextField.bottomAnchor, multiplier: 1.0),
            answerButtonsStack.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            buttonMap.topAnchor.constraint(equalToSystemSpacingBelow: answerButtonsStack.bottomAnchor, multiplier: 3.0),
            buttonMap.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            view.layoutMarginsGuide.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: buttonMap.bottomAnchor, multiplier: 1.0),
            buttonMap.widthAnchor.constraint(equalToConstant: ViewMetrics.buttonMapWidth),
            buttonMap.heightAnchor.constraint(equalToConstant: ViewMetrics.buttonMapHeight),
        ])
        
        for row in 0 ..< 4 {
            for col in 0 ..< 5 {
                let iFrame = CGRect(x: (col * ViewMetrics.buttonMapButtonWidth), y: (row * ViewMetrics.buttonMapButtonHeight), width: ViewMetrics.buttonMapButtonWidth, height: ViewMetrics.buttonMapButtonHeight)
                let letterButton = UIButton(title: "WWW", frame: iFrame)
                letterButton.addTarget(self, action: #selector(buttonMapButtonTapped), for: .touchUpInside)
                buttonMap.addSubview(letterButton)
                buttonMapButtons.append(letterButton)
            }
        }
    }
    
    private func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let level = self?.level, let levelFilePath = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") else { return }
            if let levelContents = try? String(contentsOf: levelFilePath) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                lines.enumerated().forEach({ (index, line) in
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    clueString += "\(index + 1). \(clue)\n"
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    self?.solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                })
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.correctAnswers = 0
            self.clueLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            self.answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            letterBits.shuffle()
            if letterBits.count == self.buttonMapButtons.count {
                for i in 0 ..< self.buttonMapButtons.count {
                    self.buttonMapButtons[i].setTitle(letterBits[i], for: .normal)
                }
            }
        }
    }
    
    @objc private func buttonMapButtonTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        answerTextField.text = answerTextField.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        UIView.animate(withDuration: 0.3) { sender.alpha = 0.0 }
    }
    
    @objc private func submitButtonTapped(_ sender: UIButton) {
        guard let answerText = answerTextField.text else { return }
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answerLabel.text = splitAnswers?.joined(separator: "\n")
            
            answerTextField.text = ""
            userScore += 1
            correctAnswers += 1
            
            if correctAnswers % 7 == 0 {
                let alert = UIAlertController(title: "Well Done", message: "Are you ready for the next level?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Let's Go", style: .default, handler: levelUp))
                present(alert, animated: true)
            }
        }
        else {
            userScore -= userScore > 0 ? 1 : 0
            let alert = UIAlertController(title: answerText.uppercased(), message: "That doesn't look right.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] _ in
                self?.answerTextField.text = ""
                self?.activatedButtons.forEach({ $0.isHidden = false })
                self?.activatedButtons.removeAll()
            }))
            present(alert, animated: true)
        }
    }
    
    @objc private func clearButtonTapped(_ sender: UIButton) {
        answerTextField.text = ""
        activatedButtons.forEach({ $0.alpha = 1.0 })
        activatedButtons.removeAll()
    }
    
    private func levelUp(_ action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        buttonMapButtons.forEach({ $0.alpha = 1.0 })
    }
}

private extension UILabel {
    convenience init(alignment: NSTextAlignment, color: UIColor? = .clear) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        backgroundColor = color
        textAlignment = alignment
        font = .systemFont(ofSize: RootViewController.ViewMetrics.headerLabelsFontSize)
        setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    }
}

private extension UIButton {
    convenience init(title: String) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        contentEdgeInsets = RootViewController.ViewMetrics.answerButtonsInsets
        setTitle(title, for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        titleLabel?.textAlignment = .center
        layer.cornerRadius = RootViewController.ViewMetrics.answerButtonsCornerRadius
    }
    
    convenience init(title: String, frame: CGRect) {
        self.init()
        self.frame = frame
        contentEdgeInsets = RootViewController.ViewMetrics.buttonMapButtonInsets
        setTitle(title, for: .normal)
        setTitleColor(.systemBlue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: RootViewController.ViewMetrics.buttonMapButtonFontSize)
        titleLabel?.textAlignment = .center
        layer.cornerRadius = RootViewController.ViewMetrics.buttonMapButtonCornerRadius
    }
}

