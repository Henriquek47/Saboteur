//
//  ReportModel.swift
//  Saboteur
//

import Foundation

struct ReportModel: Codable {
    let id: String
    let groupId: String
    let reportedMemberId: String
    let reportingMemberId: String
    let reportedMemberName: String
    let reportingMemberName: String
    let description: String
    let imageUrl: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case groupId = "group_id"
        case reportedMemberId = "reported_member_id"
        case reportingMemberId = "reporting_member_id"
        case reportedMemberName = "reported_member_name"
        case reportingMemberName = "reporting_member_name"
        case description
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}
