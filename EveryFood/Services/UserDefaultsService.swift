//
//  UserDefaultsService.swift
//  EveryFood
//
//  Created by Mikhail Zharkov on 24.06.2022.
//

import Foundation

final class UserDefaultsService {
    enum Key: String {
        case isLoggedIn  = "isLoggedIn"
    }
    
    func set(key: UserDefaultsService.Key, value: Any?) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func get<T>(key: UserDefaultsService.Key) -> T? {
        let value = UserDefaults.standard.object(forKey: key.rawValue)
        return value as? T
    }
    
    func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
