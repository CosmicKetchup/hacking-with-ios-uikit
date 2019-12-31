//
//  CountryTableViewController.swift
//  m02.world-flags
//
//  Created by Matt Brown on 12/7/19.
//  Copyright © 2019 Matt Brown. All rights reserved.
//

import UIKit

final class CountryTableViewController: UITableViewController {
    
    private var countries = Country.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
        setupView()
    }
    
    private func setupView() {
        navigationItem.title = "Milestone 02"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries[indexPath.item]
        let cell = CountryCell(country)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.item]
        let detailVC = CountryDetailViewController(country: country)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

