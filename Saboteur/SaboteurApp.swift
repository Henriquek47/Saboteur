//
//  SaboteurApp.swift
//  Saboteur
//
//  Created by Henrique Lima on 12/02/26.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct SaboteurApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @State private var appRouter = AppRouter()

  var body: some Scene {
    WindowGroup {
      RouterView()
        .environment(appRouter)
        .preferredColorScheme(.light)
    }
  }
}
