//
//  TaskModel.swift
//  Saboteur
//

import Foundation

struct TaskModel: Codable {
    let id: String
    let groupId: String
    let memberId: String
    let imageUrl: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case groupId = "group_id"
        case memberId = "member_id"
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
