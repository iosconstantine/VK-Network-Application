//
//  NewsfeedHeaderCell.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 28.10.2021.
//

import UIKit

class NewsfeedHeaderCell: UITableViewCell {
    static let reusedIdentifier = "NewsfeedHeaderCell"
    
    let dateFormatter: DateFormatter = {
       let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    @IBOutlet weak var avatarImage: UIImageView! {
        didSet {
            avatarImage.layer.cornerRadius = 10
            avatarImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.image = nil
        authorNameLabel.text = nil
        postDateLabel.text = nil
    }
    
    func configure(feed: FeedItem, profileOrGroup: ProfileRepresenatable?){
        guard let profile = profileOrGroup else { return }
        let date = Date(timeIntervalSince1970: TimeInterval(feed.date))
        let dateTitle = dateFormatter.string(from: date)
        postDateLabel.text = dateTitle
        authorNameLabel.text = profile.name
        let url = URL(string: profile.photo)
        guard let url = url else { return }
        avatarImage.kf.setImage(with: url)
    }
}
