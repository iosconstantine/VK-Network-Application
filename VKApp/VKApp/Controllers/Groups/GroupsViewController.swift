//
//  GroupsViewController.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 11.08.2021.
//

import UIKit
import RealmSwift

class GroupsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let realmNetworkService = RealmNetworkService()
    private let networkAlamofie = NetworkServiceAlamofire()
    private var token: NotificationToken?
    var groups: Results<MyGroups>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        getRealmGroups()
        pairRealmAndTable()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    private func getRealmGroups() {
//        realmNetworkService.getGroups { [weak self] in
//            guard let self = self else { return }
//            do {
//                let realm = try Realm()
//                let groups = realm.objects(MyGroups.self)
//                self.groups = Array(groups)
//                self.tableView.reloadData()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    private func pairRealmAndTable() {
        realmNetworkService.getGroupNotification()
        guard let realm = try? Realm() else { return }
        groups = realm.objects(MyGroups.self)
        guard let groups = groups else {
            return
        }

        
        token = groups.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update:
                tableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { action, view, complition in
            let group = self.groups?[indexPath.row]
            guard let group = group else {
                return
            }

            print("Название \(group.name)")
            self.realmNetworkService.leaveGroupRealm(id: group.id) 
        }
        action.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupsTableViewCell.identifier) as! GroupsTableViewCell
        guard let group = groups?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(group: group)
        return cell
    }
}
