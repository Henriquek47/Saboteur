//
//  RouterView.swift
//  Saboteur
//
//  Created by Henrique Lima on 07/03/26.
//

import Factory
import SwiftUI

struct RouterView: View {
  @Injected(\.authManager) private var authManager
  @Environment(AppRouter.self) private var router

  var body: some View {
    @Bindable var router = router
    NavigationStack(path: $router.path) {
      Group {
        if authManager.isLoading {
          Text("loading...")
        } else if authManager.isAuthenticated {
          MainTabView()
        } else {
          SignInView()
        }
      }
      .navigationDestination(for: AppRoute.self) { $0.view }
    }
    .onChange(of: authManager.isAuthenticated) { _, _ in
      router.path.removeLast(router.path.count)
    }
  }
}
