//
//  GroupSetupViewModel.swift
//  Saboteur
//
//  Created by Henrique Lima on 23/05/26.
//

import Factory
import Foundation
import Observation

@Observable
@MainActor
class GroupSetupViewModel {
  @Injected(\.groupManager) @ObservationIgnored private var groupManager

  var linkField: ValidatedField
  var isCreating = false
  var isJoining = false
  var errorMessage: String? = nil
  var showJoinCard = false

  init() {
    self.linkField = ValidatedField(rules: [
      AnyValidationRule(NonEmptyRule(message: "Código é obrigatório")),
      AnyValidationRule(MinLengthRule(min: 6, message: "Código deve ter 6 caracteres")),
    ])
  }

  func createGroup() async {
    isCreating = true
    errorMessage = nil
    defer { isCreating = false }
    do {
      try await groupManager.createGroup()
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func joinGroup() async {
    isJoining = true
    errorMessage = nil
    defer { isJoining = false }
    do {
      try await groupManager.joinGroup(link: linkField.value)
    } catch {
      errorMessage = error.localizedDescription
    }
  }
}
