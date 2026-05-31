//
//  ReportRepository.swift
//  Saboteur
//
//  Created by Henrique Lima on 24/05/26.
//

import Foundation

struct CreateReportRequest: Encodable {
  let reported_member_id: String
  let description: String
  let image_url: String
}

class ReportRepository {
  private let firebaseClient: FirebaseClient
  private let apiClient: ApiClient

  nonisolated init(firebaseClient: FirebaseClient, apiClient: ApiClient) {
    self.firebaseClient = firebaseClient
    self.apiClient = apiClient
  }

  func sendReport(reportedMemberId: String, description: String, imageData: Data) async throws -> ReportModel {
    // 1. Upload image to Firebase Storage
    let imageUrl = try await firebaseClient.uploadReportImage(imageData: imageData)

    // 2. Call backend POST /reports
    let payload = CreateReportRequest(
      reported_member_id: reportedMemberId,
      description: description,
      image_url: imageUrl.absoluteString
    )

    return try await apiClient.post(endpoint: "/reports", body: payload)
  }
}
