//
//  UserModel.swift
//  Saboteur
//
//  Created by Henrique Lima on 01/04/26.
//

struct UserModel: Codable {
    let uid: String
    let name: String
    let email: String
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case name
        case email
        case profileImageUrl = "photo_url"
    }
}
