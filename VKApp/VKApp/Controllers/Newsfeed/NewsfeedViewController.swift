//
//  NewsfeedViewController.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 27.10.2021.
//

import UIKit
import simd

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
        
        tableView.addSubview(refreshControl)
        tableView.separatorStyle = .none
    }
    
    private func getFirstPhoto(feedItem: FeedItem) -> Photo?{
        guard let photos = feedItem.attachments?.compactMap({ attachments in
            attachments.photo
        }), let firstPhoto = photos.first else { return nil}
        return firstPhoto
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
        case 2:
            guard
                let cell = tableView.dequeueReusableCell(withIdentifier: NewsfeedPhotoCell.reusedIdentifier, for: indexPath) as? NewsfeedPhotoCell
            else {
                return UITableViewCell()
            }
            let feedItem = feed[indexPath.section]
            let photo = getFirstPhoto(feedItem: feedItem)
            cell.configure(image: photo)
            //cell.selectionStyle = .none
            

            
            return cell
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
}
