//
//  MyGenresTableViewController.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/27/20.
//

import CloudKit
import UIKit

final class MyGenresTableViewController: UITableViewController {

    let defaults = UserDefaults.standard
    var myGenres: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        loadFavoriteGenres()
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Notify me about..."
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))
    }
    
    private func loadFavoriteGenres() {
        if let savedGenres = defaults.object(forKey: "myGenres") as? [String] {
            myGenres = savedGenres
        }
        else {
            myGenres = [String]()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SelectGenreTableViewController.genres.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let genre = SelectGenreTableViewController.genres[indexPath.row]
        
        cell.textLabel?.text = genre
        cell.accessoryType = myGenres.contains(genre) ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let selectedGenre = SelectGenreTableViewController.genres[indexPath.row]
            
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                myGenres.append(selectedGenre)
            }
            else {
                cell.accessoryType = .none
                
                if let index = myGenres.firstIndex(of: selectedGenre) {
                    myGenres.remove(at: index)
                }
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension MyGenresTableViewController {
    @objc private func saveButtonTapped() {
        defaults.setValue(myGenres, forKey: "myGenres")
        
        let database = CKContainer.default().publicCloudDatabase
        database.fetchAllSubscriptions { [weak self] (subscriptions, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let subscriptions = subscriptions else { return }
            subscriptions.forEach { database.delete(withSubscriptionID: $0.subscriptionID) { (str, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }}
            
            self?.myGenres.forEach { genre in
                let pred = NSPredicate(format: "genre = %@", genre)
                let subscription = CKQuerySubscription(recordType: SubmitViewController.whistleRecordIdentifier, predicate: pred, options: .firesOnRecordCreation)
                
                let notification = CKSubscription.NotificationInfo()
                notification.alertBody = "There's a new entry in the \(genre) genre!"
                notification.soundName = "default"
                subscription.notificationInfo = notification
                
                database.save(subscription) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return 
                    }
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}
