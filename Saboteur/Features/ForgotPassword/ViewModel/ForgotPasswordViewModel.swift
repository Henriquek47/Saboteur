//
//  ForgotPasswordViewModel.swift
//  Saboteur
//
//  Created by Henrique Lima on 12/04/26.
//

import Factory
import Foundation
import Observation

@Observable
class ForgotPasswordViewModel {
  @Injected(\.authRepository) @ObservationIgnored private var authRepository

  var email: ValidatedField

  init() {
    email = ValidatedField(rules: [
      AnyValidationRule(NonEmptyRule(message: "Email é obrigatório")),
      AnyValidationRule(EmailRule()),
    ])
  }

  var isLoading = false
  var errorMessage: String?
  var successMessage: String?

  var canSubmit: Bool {
    return email.error == nil && !email.value.isEmpty
  }

  func sendCode() async {
    guard canSubmit else { return }

    isLoading = true
    errorMessage = nil
    successMessage = nil

    do {
      try await authRepository.resetPassword(email: email.value)
      successMessage = "Código de recuperação enviado para o seu email."
    } catch {
      errorMessage = error.localizedDescription
    }

    isLoading = false
  }
}
