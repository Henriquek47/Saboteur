//
//  UserStorageService.swift
//  Saboteur
//
//  Created by Henrique Lima on 01/04/26.
//

import Foundation

class UserStorageService {
    nonisolated init() {}

    var onUserSaved: (() -> Void)?

    private let userKey = "saboteur_user_data"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func saveUser(_ user: UserModel) {
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
            onUserSaved?()
        }
    }

    func fetchUser() -> UserModel? {
        guard let data = UserDefaults.standard.data(forKey: userKey) else { return nil }
        return try? decoder.decode(UserModel.self, from: data)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
