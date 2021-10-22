//
//  RealmNetworkService.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 21.10.2021.
//

import Foundation
import Alamofire
import RealmSwift

class RealmNetworkService {
    let realmService = RealmService()
    
    func getFriends(userId: Int,
                    completion: @escaping () -> Void) {
        AF.request(FriendsRouter.getFriends(id: userId)).responseJSON { response in
            if let error = response.error {
                print(error.localizedDescription)
            }
            
            guard let data = response.data else { return }
            
            do {
                let friends = try JSONDecoder().decode(Response<Users>.self, from: data).response.items
                self.realmService.realmWrite(array: friends, completion: completion)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getGroups(completion: @escaping () -> Void) {
        AF.request(GroupsRouter.getGroups).responseJSON { response in
            if let error = response.error {
                print(error.localizedDescription)
            }
            
            guard let data = response.data else { return }
            
            do {
                let groups = try JSONDecoder().decode(Response<MyGroups>.self, from: data).response.items
                self.realmService.realmWrite(array: groups, completion: completion)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    //FIXME: - Позже в комплишн добавить ответ с сервера GroupActions и обрабатывать уже по нему
    func leaveGroupRealm(id: Int,
                         completion: @escaping () -> Void) {
        AF.request(GroupsRouter.leaveGroup(id: id)).responseJSON { response in
            if let error = response.error {
                print(error.localizedDescription)
            }
            
            do {
                let realm = try Realm()
                let group = realm.objects(MyGroups.self).filter("id == %@", id)
                try realm.write {
                    realm.delete(group)
                }
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addGroupRealm(id: Int, completion: @escaping (Result<GroupActions, NetworkError>) -> Void) {
        AF.request(GroupsRouter.joinGroup(id: id)).responseJSON { response in
            if let error = response.error {
                completion(.failure(.serverError))
                print(error.localizedDescription)
            }
            
            guard let data = response.data else {
                completion(.failure(.notData))
                return
            }
            
            do {
                let responseServer = try JSONDecoder().decode(GroupActions.self, from: data)
                completion(.success(responseServer))
            } catch {
                completion(.failure(.decodeError))
                print(error.localizedDescription)
            }
        }
    }
    
    enum NetworkError: Error {
        case decodeError
        case notData
        case serverError
    }
}

