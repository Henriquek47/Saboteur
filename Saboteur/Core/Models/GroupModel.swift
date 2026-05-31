//
//  GroupModel.swift
//  Saboteur
//

import Foundation

struct GroupModel: Codable {
    let id: String
    let link: String
    let members: [MemberModel]
    let adminMemberUserId: String
    let createdAt: String
    let reports: [ReportModel]?
    let tasks: [TaskModel]?

    enum CodingKeys: String, CodingKey {
        case id
        case link
        case members
        case adminMemberUserId = "admin_member_user_id"
        case createdAt = "created_at"
        case reports
        case tasks
    }
}
