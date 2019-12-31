//
//  AnswersTableViewController.swift
//  p05.word-scramble
//
//  Created by Matt Brown on 10/6/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class AnswersTableViewController: UITableViewController {
    
    private let wordCellIdentifier = "WordCell"
    
    private var allWords = [String]()
    private var guessedWords = [String]()
    private var sourceWord: String! {
        didSet {
            navigationItem.title = sourceWord
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWords()
        setupView()
        newGame()
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGame))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: wordCellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guessedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: wordCellIdentifier, for: indexPath)
        let guessedWord = guessedWords[indexPath.item]
        cell.textLabel?.text = guessedWord
        return cell
    }
    
    @objc private func newGame() {
        sourceWord = allWords.randomElement()
        guessedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    private func submitAnswer(_ answer: String) {
        guard isLongEnough(answer) else { showBasicAlert(title: "Too Short", message: "Size really does matter."); return }
        guard isPossible(answer) else { showBasicAlert(title: "Impossible Word", message: "You can only use letters in \(sourceWord.uppercased())."); return }
        guard isOriginal(answer) else { showBasicAlert(title: "Duplicate Word", message: "You can't use the same word more than once!"); return }
        guard isReal(answer) else { showBasicAlert(title: "Imaginary Word", message: "Well, you're just making stuff up now."); return }
        
        guessedWords.insert(answer, at: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    private func loadWords() {
        guard let filepath = Bundle.main.url(forResource: "words", withExtension: "txt"),
            let rawData = try? String(contentsOf: filepath) else { fatalError("Unable to load words.") }
        allWords = rawData.components(separatedBy: "\n")
        assert(!allWords.isEmpty)
    }
    
    @objc private func promptForAnswer() {
        let alert = UIAlertController(title: "Enter Word", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak alert] _ in
            guard let self = self, let alert = alert else { return }
            if let textFields = alert.textFields, let userEntry = textFields[0].text {
                self.submitAnswer(userEntry.lowercased())
            }
        }
        alert.addAction(submitAction)
        alert.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(alert, animated: true)
    }
    
    private func isLongEnough(_ answer: String) -> Bool {
        answer.count >= 3
    }
    
    private func isPossible(_ answer: String) -> Bool {
        var tempWord = sourceWord
        for character in answer {
            guard let position = tempWord?.firstIndex(of: character) else { return false }
            tempWord?.remove(at: position)
        }
        
        return true
    }
    
    private func isOriginal(_ answer: String) -> Bool {
        (answer != sourceWord) && (!guessedWords.contains(answer))
    }
    
    private func isReal(_ answer: String) -> Bool {
        let checker = UITextChecker()
        let fullRange = NSRange(location: 0, length: answer.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: answer, range: fullRange, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    private func showBasicAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
