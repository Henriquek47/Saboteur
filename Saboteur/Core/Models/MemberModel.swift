//
//  MemberModel.swift
//  Saboteur
//

import Foundation

struct MemberModel: Codable, Identifiable {
    var id: String { userId }
    let userId: String
    let name: String
    let score: Int
    let photoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name
        case score
        case photoUrl = "photo_url"
    }
}
