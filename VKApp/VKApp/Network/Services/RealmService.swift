//
//  RealmService.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 22.10.2021.
//

import RealmSwift

class RealmService {
    func realmWrite<T: Object>(array: [T], completion: () -> Void ) {
        do{
            let realm = try Realm()
            print(realm.configuration.fileURL)
            let oldValues = realm.objects(T.self)
            try realm.write{
                realm.delete(oldValues)
                realm.add(array)
            }
            completion()
        } catch {
            print(error.localizedDescription)
        }
    }
}
