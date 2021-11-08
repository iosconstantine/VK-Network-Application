//
//  NewsfeedViewController.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 27.10.2021.
//

import UIKit

class NewsfeedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkService = NetworkServiceAlamofire()
    var feed = [FeedItem]()
    var profileInfo = [Profile]()
    var groupInfo = [Group]()
    
    private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshh), for: .valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        
        setupTable()
        getNews()
        
    }
    
    @objc func refreshh() {
        getNews()
    }
    
    private func setupTable() {
        tableView.register(UINib(nibName: "NewsfeedHeaderCell", bundle: nil), forCellReuseIdentifier: NewsfeedHeaderCell.reusedIdentifier)
        tableView.register(UINib(nibName: "NewsfeedTextCell", bundle: nil), forCellReuseIdentifier: NewsfeedTextCell.reusedIdentifier)
        tableView.register(UINib(nibName: "NewsfeedPhotoCell", bundle: nil), forCellReuseIdentifier: NewsfeedPhotoCell.reusedIdentifier)
        tableView.register(UINib(nibName: "NewsfeedFooterCell", bundle: nil), forCellReuseIdentifier: NewsfeedFooterCell.reusedIdentifier)
        tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        
        tableView.addSubview(refreshControl)
        tableView.separatorStyle = .none
    }
    
    private func getFirstPhoto(feedItem: FeedItem) -> Photo?{
        guard let photos = feedItem.attachments?.compactMap({ attachments in
            attachments.photo
        }), let firstPhoto = photos.first else { return nil}
        return firstPhoto
    }
    
    private func getPhotos(feedItem: FeedItem) -> [Photo]{
        guard let attachments = feedItem.attachments else { return [] }
        return attachments.compactMap { attachments in
            guard let photo = attachments.photo else { return nil }
            return photo
        }
    }
    
    private func getNews() {
        networkService.getNews { result in
            switch result {
            case .success(let feedItem):
                self.feed = feedItem.items
                self.profileInfo = feedItem.profiles
                self.groupInfo = feedItem.groups
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        feed.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            //MARK: HEADER ROW
        case 0:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedHeaderCell.reusedIdentifier, for: indexPath) as? NewsfeedHeaderCell
            else {
                return UITableViewCell()
            }
            
            let feed = feed[indexPath.section]
            
            let profilesOrGroups: [ProfileRepresenatable] = feed.sourceId >= 0 ? profileInfo : groupInfo
            let sourceId = feed.sourceId >= 0 ? feed.sourceId : -feed.sourceId
            let profileRepresenatable = profilesOrGroups.first { profileOrGroup -> Bool in
                profileOrGroup.id == sourceId
            }
            cell.configure(feed: feed, profileOrGroup: profileRepresenatable)
            cell.selectionStyle = .none
            
            return cell
            //MARK: TEXT ROW
        case 1:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedTextCell.reusedIdentifier, for: indexPath) as? NewsfeedTextCell
            else {
                return UITableViewCell()
            }
            
            let feed = feed[indexPath.section]
            cell.configure(feed: feed)
            cell.selectionStyle = .none
            
            return cell
            //MARK: PHOTO ROW
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as? CollectionTableViewCell
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedPhotoCell.reusedIdentifier, for: indexPath) as? NewsfeedPhotoCell
            else {
                return UITableViewCell()
            }
            
            let feedItem = feed[indexPath.section]
            let attachments = feedItem.attachments
            
            let photos = attachments?.compactMap({ attach in
                attach.photo?.scrImage
            })
            
            let sizes = attachments?.compactMap({ attach in
                attach.photo
            })
            
            cell.configure(photos: photos ?? [], sizes: sizes ?? [])
            
            //cell.selectionStyle = .none

            return cell
            //MARK: FOOTER ROW
        case 3:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedFooterCell.reusedIdentifier, for: indexPath) as? NewsfeedFooterCell
            else {
                return UITableViewCell()
            }
            
            let feed = feed[indexPath.section]
            cell.selectionStyle = .none
            cell.configure(feed: feed)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let feedItem = feed[indexPath.section]
        let attechments = feedItem.attachments
        let photos = attechments?.compactMap({ attechments in
            attechments.photo
        })
        
        let minHeight = Float(photos?.min {
            $0.height < $1.height
        }?.height ?? 0)
        
        let minWidth = Float(photos?.min {
            $0.width < $1.width
        }?.width ?? 0)
        
        let minRatio = CGFloat(minHeight / minWidth)
        var screenWidth: CGFloat
       
        guard let photosCount = photos?.count else { return 0 }
        
        if photosCount == 0 {
            screenWidth = 0
        } else if photosCount == 1 {
            screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        } else {
            screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - 70
        }
        
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        case 2:
            return photosCount != 0 ? (screenWidth * minRatio) + 10 : 0
        case 3:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
}

