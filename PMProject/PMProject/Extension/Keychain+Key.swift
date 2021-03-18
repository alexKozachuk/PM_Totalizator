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

    func set(value: String, _ key: AuthorizationManager.Key) throws {
        try self.set(value, key: key.rawValue)
    }
}
