//
//  UserRepository.swift
//  Saboteur
//

import Foundation

struct UpdateUserRequest: Encodable {
    let name: String?
    let photo_url: String?
}

class UserRepository {
    private let apiClient: ApiClient

    nonisolated init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func getMe() async throws -> UserMemberDto {
        return try await apiClient.get(endpoint: "/users/me")
    }

    func updateMe(name: String?, photoUrl: String?) async throws -> UserModel {
        let body = UpdateUserRequest(name: name, photo_url: photoUrl)
        return try await apiClient.patch(endpoint: "/users/me", body: body)
    }
}
