//
//  HomeView.swift
//  Saboteur
//
//  Created by Henrique Lima on 02/04/26.
//

import SwiftUI

struct HomeView: View {
  @Environment(AppRouter.self) private var router
  @State private var homeViewModel: HomeViewModel = HomeViewModel()

  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        HeaderSectionView(userName: homeViewModel.userName, points: homeViewModel.myPoints)

        RankListView(
          rankList: homeViewModel.rankList,
          currentUserId: homeViewModel.currentUserId
        )

        HStack(spacing: 12) {
          InfoCardView(
            title: "Pontos totais",
            value: "\(homeViewModel.myPoints)",
            color: Color.primaryTheme
          )

          InfoCardView(
            title: "Denuncias feitas a voce",
            value: "\(homeViewModel.receivedReportsCount)",
            color: Color.red
          )

          InfoCardView(
            title: "Denuncias realizadas",
            value: "\(homeViewModel.madeReportsCount)",
            color: Color.gray
          )
        }.frame(maxWidth: .infinity)

        PointsChartView(data: homeViewModel.weeklyPoints).shimmer(
          isActive: homeViewModel.isLoadingChart)
      }
      .padding(16)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemGroupedBackground))
    .task {
      await homeViewModel.loadWeeklyPoints()
    }
  }
}

#Preview {
  HomeView()
    .environment(AppRouter())
}
