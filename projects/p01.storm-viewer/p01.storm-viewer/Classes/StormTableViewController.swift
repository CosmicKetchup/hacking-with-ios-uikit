//
//  StormTableViewController.swift
//  p01.storm-viewer
//
//  Created by Matt Brown on 10/4/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class StormTableViewController: UITableViewController {
    
    private let stormCellIdentifier = "StormCell"
    private var stormFiles = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: stormCellIdentifier)
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Project 01"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.extractStormFiles()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stormFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stormCellIdentifier, for: indexPath)
        let stormFilename = stormFiles[indexPath.item]
        cell.textLabel?.text = stormFilename
        cell.textLabel?.font = .preferredFont(forTextStyle: .body)
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stormFilename = stormFiles[indexPath.item]
        let detailVC = StormDetailViewController(file: stormFilename, metrics: (indexPath.item + 1, stormFiles.count))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
    
extension StormTableViewController {
    fileprivate func extractStormFiles() {
        guard let rootPath = Bundle.main.resourcePath, let files = try? FileManager.default.contentsOfDirectory(atPath: rootPath) else { return }
        for file in files where file.hasPrefix("nssl") {
            stormFiles.append(file)
        }
        
        stormFiles.sort()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
