//
//  NewsfeedFooterCell.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 28.10.2021.
//

import UIKit

class NewsfeedFooterCell: UITableViewCell {
    static let reusedIdentifier = "NewsfeedFooterCell"
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likeLabel.text = nil
        commentLabel.text = nil
        shareLabel.text = nil
        viewsLabel.text = nil
    }
    
    private func countFormatter(_ count: Int?) -> String? {
        guard let count = count, count > 0 else {
            return "0"
        }
        var stringCount = String(count)
        if 4...6 ~= stringCount.count {
            stringCount = String(stringCount.dropLast(3)) + "K"
        } else if stringCount.count > 6 {
            stringCount = String(stringCount.dropLast(6)) + "M"
        } else {
            return stringCount
        }

        return stringCount
    }
    
    func configure(feed: FeedItem) {    
        likeLabel.text = countFormatter(feed.likes?.count)
        commentLabel.text = countFormatter(feed.comments?.count)
        shareLabel.text = countFormatter(feed.reposts?.count)
        viewsLabel.text = countFormatter(feed.views?.count)
    }
}
