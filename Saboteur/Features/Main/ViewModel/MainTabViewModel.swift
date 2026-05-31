//
//  MainTabViewModel.swift
//  Saboteur
//

import Factory
import Foundation
import Observation

@Observable
class MainTabViewModel {
  @Injected(\.groupManager) @ObservationIgnored var groupManager
}
