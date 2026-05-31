//
//  EditPasswordView.swift
//  Saboteur
//
//  Created by Henrique Lima on 22/05/26.
//

import SwiftUI

struct EditPasswordView: View {
  @Bindable var viewModel: ProfileViewModel

  @State private var currentPasswordField = ValidatedField(rules: [
    AnyValidationRule(NonEmptyRule(message: "Senha atual é obrigatória"))
  ])
  @State private var newPasswordField = ValidatedField(rules: [
    AnyValidationRule(NonEmptyRule(message: "Nova senha é obrigatória")),
    AnyValidationRule(MinLengthRule(min: 6, message: "Mínimo de 6 caracteres")),
  ])
  @State private var confirmPasswordField = ValidatedField(rules: [
    AnyValidationRule(NonEmptyRule(message: "Confirmação é obrigatória"))
  ])

  private var passwordMismatch: Bool {
    !confirmPasswordField.value.isEmpty && confirmPasswordField.value != newPasswordField.value
  }

  private var canSave: Bool {
    !currentPasswordField.value.isEmpty && currentPasswordField.error == nil
      && !newPasswordField.value.isEmpty && newPasswordField.error == nil
      && !confirmPasswordField.value.isEmpty && confirmPasswordField.error == nil
      && !passwordMismatch
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 28) {

          Text(
            "Para alterar sua senha, confirme a senha atual e escolha uma nova com pelo menos 6 caracteres."
          )
          .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
          .foregroundColor(.secondary)
          .multilineTextAlignment(.center)
          .padding(.top, 8)

          VStack(spacing: 0) {
            CustomTextField(
              text: currentPasswordField.binding,
              placeholder: "Senha atual",
              error: currentPasswordField.error,
              isSecure: true
            )

            CustomTextField(
              text: newPasswordField.binding,
              placeholder: "Nova senha",
              error: newPasswordField.error,
              isSecure: true
            )

            CustomTextField(
              text: confirmPasswordField.binding,
              placeholder: "Confirmar nova senha",
              error: passwordMismatch ? "As senhas não coincidem" : confirmPasswordField.error,
              isSecure: true
            )
          }

          if let error = viewModel.errorMessage {
            Text(error)
              .font(.grandstander(fontStyle: .footnote, fontWeight: .regular))
              .foregroundColor(.red)
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
        .padding(24)
      }
      .navigationTitle("Editar Senha")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancelar") {
            viewModel.showEditPassword = false
          }
          .font(.grandstander(fontStyle: .body, fontWeight: .regular))
          .disabled(viewModel.isSaving)
        }

        ToolbarItem(placement: .confirmationAction) {
          if viewModel.isSaving {
            ProgressView()
          } else {
            Button("Salvar") {
              Task {
                await viewModel.updatePassword(
                  currentPassword: currentPasswordField.value,
                  newPassword: newPasswordField.value
                )
              }
            }
            .font(.grandstander(fontStyle: .body, fontWeight: .semibold))
            .disabled(!canSave)
          }
        }
      }
    }
    .interactiveDismissDisabled(viewModel.isSaving)
    .onDisappear {
      viewModel.errorMessage = nil
    }
  }
}
