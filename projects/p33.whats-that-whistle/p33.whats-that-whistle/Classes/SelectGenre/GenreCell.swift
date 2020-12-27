//
//  GenreCell.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/26/20.
//

import UIKit

typealias Genre = String

final class GenreCell: UITableViewCell, ReusableIdentifier {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        accessoryType = .disclosureIndicator
    }
    
    func configure(for genre: Genre) {
        textLabel?.text = genre
    }
}
