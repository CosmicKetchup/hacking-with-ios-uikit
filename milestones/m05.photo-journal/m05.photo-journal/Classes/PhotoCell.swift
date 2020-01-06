//
//  PhotoCell.swift
//  m05.photo-journal
//
//  Created by Matt Brown on 1/2/20.
//  Copyright © 2020 Matt Brown. All rights reserved.
//

import UIKit

final class PhotoCell: UITableViewCell, ReusableIdentifier {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        accessoryType = .disclosureIndicator
    }
    
    func configure(for photo: UserPhoto) {
        textLabel?.text = photo.caption.isEmpty ? photo.filename : photo.caption
        detailTextLabel?.text = photo.dateUploaded
    }
}
