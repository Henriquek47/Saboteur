//
//  TaskViewModel.swift
//  Saboteur
//

import Factory
import Foundation
import UIKit

@Observable
class TaskViewModel {
  @Injected(\.groupManager) @ObservationIgnored private var groupManager
  @Injected(\.taskRepository) @ObservationIgnored private var taskRepository

  var showTaskForm = false
  var isSendingTask = false

  func sendTask(image: UIImage?) async -> Bool {
    isSendingTask = true
    defer { isSendingTask = false }

    guard let image = image,
      let imageData = image.jpegData(compressionQuality: 0.8)
    else {
      print("Failed to convert image to JPEG data")
      return false
    }

    do {
      _ = try await taskRepository.sendTask(imageData: imageData)

      // Reload group to fetch updated points after task completion
      await groupManager.loadGroup(isInitialLoad: false)

      showTaskForm = false
      return true
    } catch {
      print("Failed to send task: \(error)")
      return false
    }
  }
}
