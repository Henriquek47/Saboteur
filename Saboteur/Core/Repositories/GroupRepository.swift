//
//  GroupRepository.swift
//  Saboteur
//

import Foundation

class GroupRepository {
    private let apiClient: ApiClient

    nonisolated init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }

    func getMyGroup() async throws -> GroupDtoModel {
        return try await apiClient.get(endpoint: "/groups/me")
    }

    func createGroup() async throws -> GroupDtoModel {
        return try await apiClient.post(endpoint: "/groups")
    }

    func joinGroup(link: String) async throws -> GroupDtoModel {
        return try await apiClient.post(endpoint: "/groups/join/\(link)")
    }

    func leaveGroup() async throws {
        try await apiClient.delete(endpoint: "/groups/me")
    }

    func getWeeklyChart() async throws -> [PointData] {
        return try await apiClient.get(endpoint: "/groups/me/weekly-chart")
    }
}
