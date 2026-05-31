//
//  GroupManager.swift
//  Saboteur
//

import Factory
import Foundation

@Observable
class GroupManager {
  @Injected(\.groupRepository) @ObservationIgnored private var groupRepository

  var group: GroupDtoModel? = nil
  var isLoading: Bool = false
  var hasError: Bool = false

  var hasGroup: Bool { group != nil }

  func loadGroup(isInitialLoad: Bool = false) async {
    isLoading = isInitialLoad
    hasError = false
    defer { isLoading = false }
    do {
      group = try await groupRepository.getMyGroup()
    } catch ApiClientError.requestFailed(404) {
      group = nil
    } catch ApiClientError.apiError(let detail) where detail.statusCode == 404 {
      group = nil
    } catch {
      group = nil
      hasError = true
    }
  }

  func leaveGroup() async throws {
    try await groupRepository.leaveGroup()
    group = nil
  }

  func createGroup() async throws {
    _ = try await groupRepository.createGroup()
    await loadGroup()
  }

  func joinGroup(link: String) async throws {
    _ = try await groupRepository.joinGroup(link: link)
    await loadGroup()
  }
}
