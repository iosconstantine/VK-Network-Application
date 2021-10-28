//
//  NewsfeedTextCell.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 28.10.2021.
//

import UIKit

class NewsfeedTextCell: UITableViewCell {
    static let reusedIdentifier = "NewsfeedTextCell"
    
    @IBOutlet weak var postTextLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postTextLabel.text = nil
    }
    func configure(feed: FeedItem) {
        postTextLabel.text = feed.text
    }
}
