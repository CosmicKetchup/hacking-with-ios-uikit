//
//  WebsiteTableViewController.swift
//  p04.easy-browser
//
//  Created by Matt Brown on 10/6/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class WebsiteTableViewController: UITableViewController {
    
    private let websiteCellIdentifier = "WebsiteCell"
    private let whitelistedWebsites = Website.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: websiteCellIdentifier)
        
        navigationItem.title = "Project 04"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        whitelistedWebsites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: websiteCellIdentifier, for: indexPath)
        let website = whitelistedWebsites[indexPath.item]
        cell.textLabel?.text = website.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetWebsite = whitelistedWebsites[indexPath.item]
        let webView = BrowserViewController(url: targetWebsite)
        navigationController?.pushViewController(webView, animated: true)
    }
}
