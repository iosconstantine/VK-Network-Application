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
    var groups = [MyGroups]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRealmGroups()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getRealmGroups() {
        realmNetworkService.getGroups { [weak self] in
            guard let self = self else { return }
            do {
                let realm = try Realm()
                let groups = realm.objects(MyGroups.self)
                self.groups = Array(groups)
                self.tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getGroups() {
        networkAlamofie.getGroups() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let groups):
                self.groups = groups
                self.tableView.reloadData()
            case .failure: print("Случилась ошибка")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { action, view, complition in
            let group = self.groups[indexPath.row]
            print("Название \(group.name)")
            self.realmNetworkService.leaveGroupRealm(id: group.id) {
                print("Тут будем делать нотификацию на обновление")
                self.groups.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
            }
        }
        action.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        action.image = UIImage(systemName: "trash.fill")
        return action
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GroupsTableViewCell.identifier) as! GroupsTableViewCell
        cell.configure(group: groups[indexPath.row])
        return cell
    }
}
