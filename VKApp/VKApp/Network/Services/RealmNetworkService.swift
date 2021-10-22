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
}
