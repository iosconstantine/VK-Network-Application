//
//  NewsfeedPhotoCell.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 28.10.2021.
//

import UIKit

class NewsfeedPhotoCell: UITableViewCell {
    static let reusedIdentifier = "NewsfeedPhotoCell"

    @IBOutlet weak var postImageLabel: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageLabel.image = nil
    }
    
    func configure(image: Photo?) {

        let url = URL(string: image?.scrImage ?? "")
        guard let url = url else { return }
        postImageLabel.kf.setImage(with: url)
//        postImageLabel.layer.cornerRadius = 20
//        postImageLabel.clipsToBounds = true
    }
}
