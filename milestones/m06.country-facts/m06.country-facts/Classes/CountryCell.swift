//
//  CountryCell.swift
//  m06.country-facts
//
//  Created by Matt Brown on 1/10/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class CountryCell: UITableViewCell, ReusableIdentifier {
    
    let country: Country

    init(for country: Country) {
        self.country = country
        super.init(style: .default, reuseIdentifier: CountryCell.reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        accessoryType = .disclosureIndicator
        
        textLabel?.text = country.commonName
    }
}
