//
//  RootViewController.swift
//  m04.hangman
//
//  Created by Matt Brown on 12/4/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

fileprivate enum LabelType {
    case answer, strike
    
    var textColor: UIColor {
        switch self {
        case .answer:
            return .darkGray
            
        case .strike:
            return UIColor(white: 0.0, alpha: 0.1)
        }
    }
    
    var font: UIFont {
        switch self {
        case .answer:
            return UIFont.systemFont(ofSize: 40.0)
            
        case .strike:
            return UIFont.boldSystemFont(ofSize: 72.0)
        }
    }
}

class RootViewController: UIViewController {
    
    fileprivate enum ViewMetrics {
        static let rootBackgroundColor = UIColor.white
        static let strikeLabelStackSpacing: CGFloat = 24.0
        static let answerLabelStackSpacing: CGFloat = 20.0
        
        static let guessButtonBackgroundColor = UIColor.systemBlue
        static let guessButtonContentInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
        static let guessButtonFont = UIFont.boldSystemFont(ofSize: 24.0)
        static let guessButtonCornerRadius: CGFloat = 7.0
    }
    
    private var availableWords = [String]() {
        didSet {
            if availableWords.isEmpty { endGame() }
        }
    }
    
    private var lettersInCorrectAnswer = 0
    private var guessedLetters = [Character]()
    
    private var correctGuessesForWord: Int? {
        didSet {
            if let userScore = correctGuessesForWord, (userScore > 0) && (userScore >= lettersInCorrectAnswer) { newWord() }
        }
    }
    
    private var userStrikes: Int = 0 {
        didSet {
            if userStrikes >= 7 { endGame() }
        }
    }
    
    private var currentAnswer: String? {
        didSet {
            guard let answer = currentAnswer else { return }
            generateNewLabels(for: answer)
        }
    }
    
    private let strikeLabel1 = UILabel(type: .strike, tag: 1)
    private let strikeLabel2 = UILabel(type: .strike, tag: 2)
    private let strikeLabel3 = UILabel(type: .strike, tag: 3)
    private let strikeLabel4 = UILabel(type: .strike, tag: 4)
    private let strikeLabel5 = UILabel(type: .strike, tag: 5)
    private let strikeLabel6 = UILabel(type: .strike, tag: 6)
    private let strikeLabel7 = UILabel(type: .strike, tag: 7)
    
    private lazy var strikeLabelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [strikeLabel1, strikeLabel2, strikeLabel3, strikeLabel4, strikeLabel5, strikeLabel6, strikeLabel7])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = ViewMetrics.strikeLabelStackSpacing
        return stack
    }()
    
    private let answerLabelStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = ViewMetrics.answerLabelStackSpacing
        return stack
    }()
    
    private let guessLetterButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ViewMetrics.guessButtonBackgroundColor
        button.contentEdgeInsets = ViewMetrics.guessButtonContentInsets
        button.addTarget(self, action: #selector(guessButtonTapped), for: .touchUpInside)
        
        button.titleLabel?.font = ViewMetrics.guessButtonFont
        button.setTitle("GUESS LETTER", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        
        button.layer.cornerRadius = ViewMetrics.guessButtonCornerRadius
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        newGame()
    }

    private func setupView() {
        view.backgroundColor = ViewMetrics.rootBackgroundColor
        navigationItem.title = "Milestone 04"
        
        [strikeLabelStack, answerLabelStack, guessLetterButton].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            strikeLabelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            answerLabelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerLabelStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            answerLabelStack.topAnchor.constraint(equalToSystemSpacingBelow: strikeLabelStack.bottomAnchor, multiplier: 7.0),
            answerLabelStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
            view.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: answerLabelStack.trailingAnchor),
            
            guessLetterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guessLetterButton.topAnchor.constraint(equalToSystemSpacingBelow: answerLabelStack.bottomAnchor, multiplier: 7.0),
        ])
    }
}
extension RootViewController {
    fileprivate func fetchWords() {
        guard let inputFile = Bundle.main.url(forResource: "input", withExtension: "txt"),
            let contents = try? String(contentsOf: inputFile) else { return }
        availableWords = contents
            .components(separatedBy: "\n")
            .compactMap { str in
                guard !str.isEmpty else { return nil }
                return str.uppercased() }
            .shuffled()
    }
    
    fileprivate func newGame() {
        fetchWords()
        newWord()
    }
    
    private func newWord() {
        guessedLetters.removeAll(keepingCapacity: true)
        userStrikes = 0
        resetStrikes()
        correctGuessesForWord = 0
        currentAnswer = availableWords.popLast()
        if let currentAnswer = currentAnswer { lettersInCorrectAnswer = currentAnswer.count }
    }
    
    private func generateNewLabels(for answer: String) {
        answerLabelStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        answer.enumerated().forEach { [weak self] (index, _) in
            let label = UILabel(type: .answer, tag: index + 1)
            self?.answerLabelStack.addArrangedSubview(label)
        }
    }
    
    @objc private func guessButtonTapped() {
        let alert = UIAlertController(title: "Guess Letter", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, alert] _ in
            guard let currentAnswer = self?.currentAnswer else { return }
            guard let textFields = alert.textFields, let userEntry = textFields.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().first else { return }
            guard userEntry.isLetter else { self?.notLetter(userEntry); return }
            guard let guessedLetters = self?.guessedLetters, !guessedLetters.contains(userEntry) else { self?.duplicateLetter(userEntry); return }
            self?.guessedLetters.append(userEntry)
            currentAnswer.contains(userEntry) ? self?.correctGuess(userEntry) : self?.addStrike()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func correctGuess(_ userEntry: Character) {
        guard let currentAnswer = currentAnswer else { return }
        currentAnswer.enumerated().forEach { [weak self] (index, char) in
            guard char == userEntry else { return }
            if let answerLabel = self?.answerLabelStack.viewWithTag(index + 1) as? UILabel, let userScore = self?.correctGuessesForWord {
                answerLabel.text = String(char)
                self?.correctGuessesForWord = userScore + 1
            }
        }
    }
    
    private func addStrike() {
        userStrikes += 1
        if let strikeLabel = strikeLabelStack.viewWithTag(userStrikes) as? UILabel {
            strikeLabel.textColor = .red
        }
    }
    
    private func resetStrikes() {
        userStrikes = 0
        strikeLabelStack.arrangedSubviews.forEach { label in
            guard let strikeLabel = label as? UILabel else { return }
            strikeLabel.textColor = LabelType.strike.textColor
        }
    }
    
    private func endGame() {
        let alert = UIAlertController(title: "Game Over", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            self?.newGame()
        })
        present(alert, animated: true)
    }
    
    func duplicateLetter(_ char: Character) {
        let alert = UIAlertController(title: "Oops!", message: "You've already guessed the letter \(String(char)).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func notLetter(_ char: Character) {
        let alert = UIAlertController(title: "Oops!", message: "Bummer, but \(String(char)) is not a letter.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default))
        present(alert, animated: true)
    }
}

private extension UILabel {
    convenience init(type: LabelType, tag: Int) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        self.tag = tag
        isUserInteractionEnabled = false
        
        text = (type == .strike) ? "X" : "_"
        font = type.font
        textAlignment = .center
        textColor = type.textColor
        backgroundColor = .clear
    }
}

