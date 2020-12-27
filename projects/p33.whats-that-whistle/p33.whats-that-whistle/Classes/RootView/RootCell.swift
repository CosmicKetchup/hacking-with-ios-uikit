//
//  RootCell.swift
//  p33.whats-that-whistle
//
//  Created by Matt Brown on 12/26/20.
//

import UIKit

final class RootCell: UITableViewCell, ReusableIdentifier {
    private enum ViewMetrics {
        static let backgroundColor = UIColor.clear
        
        static let titleFont = UIFont.preferredFont(forTextStyle: .headline)
        static let titleTextColor = UIColor.purple
        
        static let subtitleFont = UIFont.preferredFont(forTextStyle: .subheadline)
        static let subtitleTextColor = UIColor.secondaryLabel
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = ViewMetrics.backgroundColor
    }
    
    func configure(for whistle: Whistle) {
        textLabel?.numberOfLines = 0
        textLabel?.attributedText = attributedString(title: whistle.genre, comment: whistle.comment)
        
        accessoryType = .disclosureIndicator
    }
}

extension RootCell {
    private func attributedString(title: String, comment: String) -> NSAttributedString {
        let titleAttributes = [
            NSAttributedString.Key.font: ViewMetrics.titleFont,
            .foregroundColor: ViewMetrics.titleTextColor,
        ]
        let subtitleAttributes = [
            NSAttributedString.Key.font: ViewMetrics.subtitleFont,
            .foregroundColor: ViewMetrics.subtitleTextColor,
        ]
        
        
        let titleString = NSMutableAttributedString(string: "\(title)", attributes: titleAttributes)
        
        if comment.count > 0 {
            let subtitleString = NSAttributedString(string: "\n\(comment)", attributes: subtitleAttributes)
            titleString.append(subtitleString)
        }
        
        return titleString
    }
}
