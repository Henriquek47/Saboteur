//
//  HomeViewModel.swift
//  Saboteur
//
//  Created by Henrique Lima on 02/04/26.
//

import Factory
import FirebaseAuth
import Foundation

@Observable
class HomeViewModel {
  @Injected(\.authManager) @ObservationIgnored private var authManager
  @Injected(\.groupManager) @ObservationIgnored private var groupManager
  @Injected(\.groupRepository) @ObservationIgnored private var groupRepository

  var rankList: [MemberModel] {
    let members = groupManager.group?.members ?? []
    return members.sorted(by: { $0.score > $1.score })
  }

  var currentUserId: String? {
    authManager.user?.uid
  }

  var userName: String {
    authManager.user?.displayName ?? "Usuário"
  }

  var myPoints: Int {
    groupManager.group?.members.first(where: { $0.userId == currentUserId })?.score ?? 0
  }

  var receivedReportsCount: Int {
    groupManager.group?.receivedReportsCount ?? 0
  }

  var madeReportsCount: Int {
    groupManager.group?.reports.count ?? 0
  }

  var weeklyPoints: [PointData] = []
  var isLoadingChart: Bool = false

  func loadWeeklyPoints() async {
    isLoadingChart = true
    defer { isLoadingChart = false }
    do {
      weeklyPoints = try await groupRepository.getWeeklyChart()
    } catch {
      print("Failed to load weekly chart: \(error)")
    }
  }

  func signOut() throws {
    try authManager.signOut()
  }
}
