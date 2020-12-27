//
//  RootTableViewController.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/25/20.
//

import CloudKit
import UIKit

final class RootTableViewController: UITableViewController {
    private enum ViewMetrics {
        static let backgroundColor = UIColor.secondarySystemBackground
    }
    
    static var isDirty = true
    private var whistles = [Whistle]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RootCell.self, forCellReuseIdentifier: RootCell.reuseIdentifier)
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if RootTableViewController.isDirty {
            loadWhistles()
        }
    }
    
    private func setupView() {
        navigationItem.title = "Project 33"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Genres", style: .plain, target: self, action: #selector(genresButtonTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        
        tableView.backgroundColor = ViewMetrics.backgroundColor
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        whistles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RootCell.reuseIdentifier, for: indexPath) as? RootCell else { fatalError() }
        let whistle = whistles[indexPath.row]
        cell.configure(for: whistle)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let whistle = whistles[indexPath.row]
        let resultsVC = ResultsTableViewController(whistle: whistle)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}

extension RootTableViewController {
    @objc private func addButtonTapped() {
        let recordVC = RecordWhistleViewController()
        navigationController?.pushViewController(recordVC, animated: true)
    }
    
    @objc private func genresButtonTapped() {
        let genreViewController = MyGenresTableViewController()
        navigationController?.pushViewController(genreViewController, animated: true)
    }
}

extension RootTableViewController {
    private func loadWhistles() {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: SubmitViewController.whistleRecordIdentifier, predicate: pred)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["genre", "comment"]
        operation.resultsLimit = 50
        
        var newWhistles = [Whistle]()
        
        operation.recordFetchedBlock = { (record) in
            let whistle = Whistle()
            whistle.recordID = record.recordID
            whistle.genre = record["genre"]
            whistle.comment = record["comment"]
            newWhistles.append(whistle)
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            DispatchQueue.main.async { [weak self] in
                if error != nil {
                    let alert = UIAlertController(title: "Fetch Error", message: "There was a problem fetching the list of user submissions.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
                else {
                    RootTableViewController.isDirty = false
                    self?.whistles = newWhistles
                    self?.tableView.reloadData()
                }
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

