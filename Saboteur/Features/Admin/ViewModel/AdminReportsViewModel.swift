//
//  AdminReportsViewModel.swift
//  Saboteur
//

import Factory
import Foundation

@Observable
class AdminReportsViewModel {
  @Injected(\.reportRepository) @ObservationIgnored private var reportRepository

  var reports: [ReportModel] = []
  var isLoading = false
  var isLoadingMore = false
  var hasLoaded = false
  var hasMorePages = true
  var errorMessage: String?

  private var currentPage = 1
  private let pageSize = 20

  func refresh() async {
    await load(page: 1, replacing: true)
  }

  func loadMoreIfNeeded(currentReport: ReportModel) async {
    guard reports.last?.id == currentReport.id else { return }
    guard hasMorePages, !isLoadingMore, !isLoading else { return }
    await load(page: currentPage + 1, replacing: false)
  }

  func deleteReport(id: String) async {
    do {
      try await reportRepository.deleteReport(id: id)
      reports.removeAll { $0.id == id }
    } catch {
      errorMessage = "Não foi possível excluir a denúncia."
      print("Failed to delete report: \(error)")
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
      let response = try await reportRepository.listReports(page: page, pageSize: pageSize)
      reports = replacing ? response.items : reports + response.items
      currentPage = response.page
      hasMorePages = response.page < response.totalPages
    } catch {
      if replacing {
        reports = []
      }
      errorMessage = "Não foi possível carregar as denúncias."
      print("Failed to load reports: \(error)")
    }
  }
}
