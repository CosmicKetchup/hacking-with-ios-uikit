//
//  RootTableViewController.swift
//  m06.country-facts
//
//  Created by Matt Brown on 1/8/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class RootTableViewController: UITableViewController {
    
    private var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCountries()
        setupView()
    }

    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Milestone 06"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let targetCountry = countries[indexPath.row]
        let cell = CountryCell(for: targetCountry)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = countries[indexPath.row]
        let detailVC = DetailViewController(for: selectedCountry)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension RootTableViewController {
    fileprivate func loadCountries() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let countryFile = Bundle.main.url(forResource: "countries", withExtension: "json") else { return }
            
            do {
                let countryData = try Data(contentsOf: countryFile)
                self?.countries = try JSONDecoder().decode([Country].self, from: countryData).sorted()
                DispatchQueue.main.async { self?.tableView.reloadData() }
            }
            catch {
                print("Unable to parse JSON file.")
            }
        }
    }
}

