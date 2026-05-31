//
//  UserMemberDto.swift
//  Saboteur
//

import Foundation

struct UserMemberDto: Codable {
    let user: UserModel
    let member: MemberModel?
    
    init(user: UserModel, member: MemberModel?) {
        self.user = user
        self.member = member
    }

    init(from decoder: Decoder) throws {
        self.user = try UserModel(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.member = try container.decodeIfPresent(MemberModel.self, forKey: .member)
    }
    
    func encode(to encoder: Encoder) throws {
        try user.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(member, forKey: .member)
    }
    
    enum CodingKeys: String, CodingKey {
        case member
    }
}
