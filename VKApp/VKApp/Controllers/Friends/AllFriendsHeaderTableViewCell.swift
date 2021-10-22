//
//  AllFriendsHeaderTableViewCell.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 27.08.2021.
//

import UIKit

class AllFriendsHeaderTableViewCell: UITableViewHeaderFooterView {
    static let identifier = "AllFriendsHeaderTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ text: String?) {
        label.text = text
    }
    
    private func setupViews() {
        contentView.addSubview(label)
        let labelTopAnchor = label.topAnchor.constraint(equalTo: contentView.topAnchor)
        labelTopAnchor.priority = UILayoutPriority.init(999)
        NSLayoutConstraint.activate([
            labelTopAnchor,
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.heightAnchor.constraint(equalToConstant: 30),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
