//
//  AdminTasksViewModel.swift
//  Saboteur
//

import Factory
import Foundation

@Observable
class AdminTasksViewModel {
  @Injected(\.taskRepository) @ObservationIgnored private var taskRepository
  @Injected(\.groupManager) @ObservationIgnored private var groupManager

  var tasks: [TaskModel] = []
  var isLoading = false
  var isLoadingMore = false
  var hasLoaded = false
  var hasMorePages = true
  var errorMessage: String?

  private var currentPage = 1
  private let pageSize = 20

  func memberName(for memberId: String) -> String {
    groupManager.group?.members.first(where: { $0.userId == memberId })?.name ?? "Membro"
  }

  func refresh() async {
    await load(page: 1, replacing: true)
  }

  func loadMoreIfNeeded(currentTask: TaskModel) async {
    guard tasks.last?.id == currentTask.id else { return }
    guard hasMorePages, !isLoadingMore, !isLoading else { return }
    await load(page: currentPage + 1, replacing: false)
  }

  func deleteTask(id: String) async {
    do {
      try await taskRepository.deleteTask(id: id)
      tasks.removeAll { $0.id == id }
    } catch {
      errorMessage = "Não foi possível excluir a tarefa."
      print("Failed to delete task: \(error)")
    }
  }

  private func load(page: Int, replacing: Bool) async {
    if replacing {
      isLoading = true
      errorMessage = nil
    } else {
      isLoadingMore = true
    }

    defer {
      isLoading = false
      isLoadingMore = false
      hasLoaded = true
    }

    do {
      let response = try await taskRepository.listTasks(page: page, pageSize: pageSize)
      tasks = replacing ? response.items : tasks + response.items
      currentPage = response.page
      hasMorePages = response.page < response.totalPages
    } catch {
      if replacing {
        tasks = []
      }
      errorMessage = "Não foi possível carregar as tarefas."
      print("Failed to load tasks: \(error)")
    }
  }
}
