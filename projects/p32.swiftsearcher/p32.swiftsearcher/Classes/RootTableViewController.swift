//
//  RootTableViewController.swift
//  p32.swiftsearcher
//
//  Created by Matt Brown on 12/24/20.
//

import CoreSpotlight
import MobileCoreServices
import SafariServices
import UIKit

final class RootTableViewController: UITableViewController {
    let favoritesDataKey = "favorites"
    let defaults = UserDefaults.standard
    
    private var projects = [[String]]()
    private var favorites = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
        setupView()
        loadFromUserDefaults()
    }

    private func setupView() {
        navigationItem.title = "Project 32"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(RootCell.self, forCellReuseIdentifier: RootCell.reuseIdentifier)
        tableView.allowsSelectionDuringEditing = true
        tableView.isEditing = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        projects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RootCell.reuseIdentifier, for: indexPath) as? RootCell else { fatalError() }
        let project = projects[indexPath.row]
        cell.configureFor(project, asFav: favorites.contains(indexPath.row))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        favorites.contains(indexPath.row) ? .delete : .insert
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .insert {
            favorites.append(indexPath.row)
            index(item: indexPath.row)
        }
        else {
            if let index = favorites.firstIndex(of: indexPath.row) {
                favorites.remove(at: index)
                deindex(item: indexPath.row)
            }
        }
        
        saveToUserDefaults()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

private extension RootTableViewController {
    func configureData() {
        projects.append(["Project 1: Storm Viewer", "Constants and variables, UITableView, UIImageView, FileManager, storyboards"])
        projects.append(["Project 2: Guess the Flag", "@2x and @3x images, asset catalogs, integers, doubles, floats, operators (+= and -=), UIButton, enums, CALayer, UIColor, random numbers, actions, string interpolation, UIAlertController"])
        projects.append(["Project 3: Social Media", "UIBarButtonItem, UIActivityViewController, the Social framework, URL"])
        projects.append(["Project 4: Easy Browser", "loadView(), WKWebView, delegation, classes and structs, URLRequest, UIToolbar, UIProgressView., key-value observing"])
        projects.append(["Project 5: Word Scramble", "Closures, method return values, booleans, NSRange"])
        projects.append(["Project 6: Auto Layout", "Get to grips with Auto Layout using practical examples and code"])
        projects.append(["Project 7: Whitehouse Petitions", "JSON, Data, UITabBarController"])
        projects.append(["Project 8: 7 Swifty Words", "addTarget(), enumerated(), count, index(of:), property observers, range operators."])
    }
    
    func loadFromUserDefaults() {
        if let savedFavorites = defaults.object(forKey: favoritesDataKey) as? [Int] {
            favorites = savedFavorites
        }
    }
    
    func saveToUserDefaults() {
        defaults.set(favorites, forKey: favoritesDataKey)
    }
    
    func index(item: Int) {
        let project = projects[item]
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = project[0]
        attributeSet.contentDescription = project[1]
        
        let item = CSSearchableItem(uniqueIdentifier: "\(item)", domainIdentifier: "com.hackingwithswift", attributeSet: attributeSet)
        item.expirationDate = .distantFuture
        
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing Error: \(error.localizedDescription)")
            }
            else {
                print("Search item successfully indexed!")
            }
        }
    }
    
    func deindex(item: Int) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(item)"]) { error in
            if let error = error {
                print("Deindexing Error: \(error.localizedDescription)")
            }
            else {
                print("Search item successfully removed.")
            }
        }
    }
}

extension RootTableViewController {
    func showTutorial(_ which: Int) {
        guard let url = URL(string: "https://hackingwithswift.com/read/\(which + 1)") else { return }
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
    }
}

