//
//  ResultsTableViewController.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/27/20.
//

import AVFoundation
import CloudKit
import UIKit

typealias Suggestion = String

final class ResultsTableViewController: UITableViewController {
    private enum ViewMetrics {
        static let backgroundColor = UIColor.secondarySystemBackground
    }
    
    static let suggestionRecordIdentifier = "Suggestions"
    
    private var whistlePlayer: AVAudioPlayer!
    private let whistle: Whistle
    private var suggestions = [Suggestion]()
    
    init(whistle: Whistle) {
        self.whistle = whistle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let reference = CKRecord.Reference(recordID: whistle.recordID, action: .deleteSelf)
        let pred = NSPredicate(format: "parentWhistle == %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: true)
        let query = CKQuery(recordType: ResultsTableViewController.suggestionRecordIdentifier, predicate: pred)
        query.sortDescriptors = [sort]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { [weak self] (results, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let results = results else { fatalError() }
            self?.parseResults(results)
        }
        
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Genre: \(whistle.genre ?? "Unknown")"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadButtonTapped))
        
        tableView.backgroundColor = ViewMetrics.backgroundColor
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Suggestions"
        }
        else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return suggestions.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.section == 0 {
            cell.textLabel?.font = .preferredFont(forTextStyle: .title1)
            cell.textLabel?.text = whistle.comment.count == 0 ? "No Comment Provided" : whistle.comment
        }
        else {
            cell.textLabel?.font = .preferredFont(forTextStyle: .body)
            
            if indexPath.row == suggestions.count {
                cell.textLabel?.text = "Add Suggestion"
                cell.selectionStyle = .gray
            }
            else {
                cell.textLabel?.text = suggestions[indexPath.row]
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (indexPath.section == 1) && (indexPath.row == suggestions.count) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Add Suggestion", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let textField = alert.textFields?[0], let userEntry = textField.text, userEntry.count > 0 else { return }
            self?.add(suggestion: userEntry)
        }
        
        alert.addAction(submitAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

extension ResultsTableViewController {
    @objc private func downloadButtonTapped() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.tintColor = .secondaryLabel
        spinner.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: whistle.recordID) { [weak self] (record, error) in
            guard let self = self else { return }
            
            if let _ = error {
                DispatchQueue.main.async { [weak self] in
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(self?.downloadButtonTapped))
                    #warning("Add meanaingful error message.")
                    return
                }
            }
            
            guard let record = record, let asset = record["audio"] as? CKAsset else { fatalError() }
            self.whistle.audioURL = asset.fileURL
            
            DispatchQueue.main.async { [weak self] in
                self?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Listen", style: .plain, target: self, action: #selector(self?.listenButtonTapped))
            }
        }
    }
    
    @objc private func listenButtonTapped() {
        do {
            whistlePlayer = try AVAudioPlayer(contentsOf: whistle.audioURL)
            whistlePlayer.play()
        }
        catch {
            let alert = UIAlertController(title: "Playback Error", message: "There was a problem playing the audio file. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func add(suggestion: Suggestion) {
        let whistleRecord = CKRecord(recordType: ResultsTableViewController.suggestionRecordIdentifier)
        let reference = CKRecord.Reference(recordID: whistle.recordID, action: .deleteSelf)
        whistleRecord["text"] = suggestion as CKRecordValue
        whistleRecord["parentWhistle"] = reference as CKRecordValue
        
        CKContainer.default().publicCloudDatabase.save(whistleRecord) { (record, error) in
            DispatchQueue.main.async { [weak self] in
                if let error = error {
                    let alert = UIAlertController(title: "Upload Error", message: "There was a problem submitting your suggestion: \(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
                else {
                    self?.suggestions.append(suggestion)
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func parseResults(_ records: [CKRecord]) {
        var newSuggestions = [Suggestion]()
        records.forEach { record in
            if let suggestion = record["text"] as? Suggestion {
                newSuggestions.append(suggestion)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.suggestions = newSuggestions
            self?.tableView.reloadData()
        }
    }
}
