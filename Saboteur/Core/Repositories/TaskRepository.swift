//
//  TaskRepository.swift
//  Saboteur
//

import Foundation

struct CreateTaskRequest: Encodable {
  let image_url: String
}

class TaskRepository {
  private let firebaseClient: FirebaseClient
  private let apiClient: ApiClient

  nonisolated init(firebaseClient: FirebaseClient, apiClient: ApiClient) {
    self.firebaseClient = firebaseClient
    self.apiClient = apiClient
  }

  func sendTask(imageData: Data) async throws -> TaskModel {
    // 1. Upload image to Firebase Storage
    let imageUrl = try await firebaseClient.uploadTaskImage(imageData: imageData)

    // 2. Call backend POST /tasks
    let payload = CreateTaskRequest(
      image_url: imageUrl.absoluteString
    )

    return try await apiClient.post(endpoint: "/tasks", body: payload)
  }

  func listTasks(page: Int = 1, pageSize: Int = 20) async throws -> PaginatedResponse<TaskModel> {
    try await apiClient.get(endpoint: "/tasks?page=\(page)&page_size=\(pageSize)")
  }

  func deleteTask(id: String) async throws {
    try await apiClient.delete(endpoint: "/tasks/\(id)")
  }
}
