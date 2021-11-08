//
//  CollectionTableViewCell.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 29.10.2021.
//

import UIKit

class CollectionTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var galleryCollcectionView: UICollectionView!

    var photos = [String]()
    var sizes = [Photo]()
   
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photos = []
        galleryCollcectionView.reloadData()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
//        flowLayout.itemSize = CGSize(width: 400, height: 200)
        flowLayout.minimumInteritemSpacing = 1
        galleryCollcectionView.collectionViewLayout = flowLayout
        galleryCollcectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        galleryCollcectionView.dataSource = self
        galleryCollcectionView.delegate = self
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

        let minHeight = Float(sizes.min {
            $0.height < $1.height
        }?.height ?? 0)
        let minWidth = Float(sizes.min {
            $0.width < $1.width
        }?.width ?? 0)
        let minRation = CGFloat(minHeight / minWidth)
        
        var size: CGSize
        if photos.count == 0 {
            size = CGSize(width: screenWidth, height: 0)
        } else if photos.count == 1 {
            size = CGSize(width: screenWidth, height: screenWidth * minRation)
        } else {
            size = CGSize(width: screenWidth - 70, height: (screenWidth - 70) * minRation)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        if !photos.isEmpty {
            let photo = photos[indexPath.row]
            cell.configure(image: photo)
        }
         
        return cell
    }
    
    func configure(photos: [String], sizes: [Photo]) {
        self.photos = photos
        self.sizes = sizes
        galleryCollcectionView.reloadData()
    }
    
}
