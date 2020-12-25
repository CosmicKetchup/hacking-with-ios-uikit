//
//  RootCell.swift
//  p32.swiftsearcher
//
//  Created by Matt Brown on 12/24/20.
//

import UIKit

import Foundation

protocol ReusableIdentifier: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableIdentifier {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

final class RootCell: UITableViewCell, ReusableIdentifier {
    private enum ViewMetrics {
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        textLabel?.numberOfLines = 0
    }
    
    func configureFor(_ project: [String], asFav: Bool = false) {
        textLabel?.attributedText = attributedString(title: project[0], subtitle: project[1])
        editingAccessoryType = asFav ? .checkmark : .none
    }
    
    private func attributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), .foregroundColor: UIColor.purple]
        let subtitleAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: "\(title)\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: subtitle, attributes: subtitleAttributes)
        
        titleString.append(subtitleString)
        return titleString
    }
}
