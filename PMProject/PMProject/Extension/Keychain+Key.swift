//
//  Keychain+String.swift
//  PMProject
//
//  Created by Ilya Senchukov on 18.03.2021.
//

import KeychainAccess

extension Keychain {

    func get(_ key: AuthorizationManager.Key) -> String? {
        self[key.rawValue]
    }

    func set(_ value: String, key: AuthorizationManager.Key) throws {
        try self.set(value, key: key.rawValue)
    }

    func remove(_ key: AuthorizationManager.Key) throws {
        try self.remove(key.rawValue)
    }
}
