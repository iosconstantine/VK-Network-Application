//
//  RealmManager.swift
//  VKApp
//
//  Created by KONSTANTIN TISHCHENKO on 21.10.2021.
//

import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    
    private init() {}
    
    let localRealm = try! Realm()
    
    func saveModel<T: Object>(model: T) {
        do {
            try localRealm.write {
                localRealm.add(model)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteModel<T: Object>(model: T)  {
        do {
            try localRealm.write {
                localRealm.delete(model)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
