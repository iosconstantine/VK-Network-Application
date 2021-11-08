//
//  GalleryCollectionViewCell.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 29.10.2021.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.layer.cornerRadius = 10
        postImageView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    func configure(image: String?) {
        let url = URL(string: image ?? "")
        guard let url = url else { return }
        postImageView.kf.setImage(with: url)
    }

}
