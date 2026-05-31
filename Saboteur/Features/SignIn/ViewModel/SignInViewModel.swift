//
//  SignInViewModel.swift
//  Saboteur
//
//  Created by Henrique Lima on 01/04/26.
//

import Factory
import FirebaseAuth
import FirebaseFirestore
import Foundation
import Observation

@Observable
@MainActor
class SignInViewModel {
  @Injected(\.authRepository) @ObservationIgnored private var authRepository

  var email: ValidatedField
  var password: ValidatedField

  init() {
    email = ValidatedField(rules: [
      AnyValidationRule(NonEmptyRule(message: "Email é obrigatório")),
      AnyValidationRule(EmailRule()),
    ])

    password = ValidatedField(rules: [
      AnyValidationRule(NonEmptyRule(message: "Senha é obrigatória")),
      AnyValidationRule(MinLengthRule(min: 8, message: "Mínimo 8 caracteres")),
    ])
  }

  var isLoading = false
  var errorMessage: String?

  var canSubmit: Bool {
    let noErrors = email.error == nil && password.error == nil
    let allFilled = !email.value.isEmpty && !password.value.isEmpty

    return noErrors && allFilled
  }

  func signIn() async {
    guard canSubmit else { return }

    isLoading = true
    errorMessage = nil

    do {
      try await authRepository.signIn(
        email: email.value,
        password: password.value
      )
    } catch {
      errorMessage = error.localizedDescription
    }

    isLoading = false
  }

  func signInWithGoogle() async {
    isLoading = true
    errorMessage = nil

    do {
      try await authRepository.signInGoogle()
    } catch {
      errorMessage = error.localizedDescription
    }

    isLoading = false
  }
}
