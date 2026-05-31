import Factory
import FirebaseAuth
import Foundation
import UIKit

@Observable
class ReportViewModel {
  @Injected(\.groupManager) @ObservationIgnored private var groupManager
  @Injected(\.authManager) @ObservationIgnored private var authManager
  @Injected(\.reportRepository) @ObservationIgnored private var reportRepository

  var showReportForm = false
  var isSendingReport = false

  var currentUserId: String? {
    authManager.user?.uid
  }

  var members: [MemberModel] {
    let list = groupManager.group?.members ?? []
    return list.sorted(by: { $0.score > $1.score })
  }

  func sendReport(reportedMemberId: String, description: String, image: UIImage?) async -> Bool {
    isSendingReport = true
    defer { isSendingReport = false }

    guard let image = image,
      let imageData = image.jpegData(compressionQuality: 0.8)
    else {
      print("Failed to convert image to JPEG data")
      return false
    }

    do {
      _ = try await reportRepository.sendReport(
        reportedMemberId: reportedMemberId,
        description: description,
        imageData: imageData
      )

      await groupManager.loadGroup(isInitialLoad: false)

      showReportForm = false
      return true
    } catch {
      print("Failed to send report: \(error)")
      return false
    }
  }
}
