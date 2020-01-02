//
//  StormTableViewController.swift
//  p01.storm-viewer
//
//  Created by Matt Brown on 10/4/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class StormTableViewController: UITableViewController {
    
    private enum ViewMetrics {
        static let cellTextLabelFont = UIFont.preferredFont(forTextStyle: .body)
        static let cellDetailTextLabelFont = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    private let stormCellIdentifier = "StormCell"
    private var stormFiles = [Storm]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: stormCellIdentifier)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupView() {
        navigationItem.title = "Project 01"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.loadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stormFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: stormCellIdentifier, for: indexPath)
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: stormCellIdentifier)
        let storm = stormFiles[indexPath.item]
        
        cell.textLabel?.text = storm.filename
        cell.textLabel?.font = ViewMetrics.cellTextLabelFont
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        
        cell.detailTextLabel?.text = "Total Views: \(storm.viewCount)"
        cell.detailTextLabel?.font = ViewMetrics.cellDetailTextLabelFont
        cell.detailTextLabel?.adjustsFontForContentSizeCategory = true
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storm = stormFiles[indexPath.item]
        storm.incrementViewCount()
        let detailVC = StormDetailViewController(storm: storm, metrics: (num: indexPath.item + 1, of: stormFiles.count))
        saveData()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
    
extension StormTableViewController {
    fileprivate func saveData() {
        let defaults = UserDefaults.standard
        if let savedData = try? JSONEncoder().encode(stormFiles) {
            defaults.set(savedData, forKey: "savedStorms")
        }
        else {
            print("Unable to save storm data.")
        }
    }
    
    fileprivate func loadData() {
        let defaults = UserDefaults.standard
        guard let savedData = defaults.object(forKey: "savedStorms") as? Data else { extractStormFiles(); return }
        
        do {
            stormFiles = try JSONDecoder().decode([Storm].self, from: savedData)
            DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
        }
        catch {
            print("Failed to load saved storm data.")
        }
    }
    
    fileprivate func extractStormFiles() {
        guard let rootPath = Bundle.main.resourcePath, let files = try? FileManager.default.contentsOfDirectory(atPath: rootPath) else { return }
        for file in files where file.hasPrefix("nssl") {
            let storm = Storm(filename: file)
            stormFiles.append(storm)
        }
        
        stormFiles.sort()
        DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
    }
}
