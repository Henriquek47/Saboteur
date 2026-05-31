//
//  DeleteAccountView.swift
//  Saboteur
//
//  Created by Henrique Lima on 22/05/26.
//

import SwiftUI

struct DeleteAccountView: View {
  @Bindable var viewModel: ProfileViewModel

  @State private var passwordField = ValidatedField(rules: [
    AnyValidationRule(NonEmptyRule(message: "Senha é obrigatória"))
  ])

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 28) {

          // MARK: – Ícone de aviso
          ZStack {
            Circle()
              .fill(Color.red.opacity(0.12))
              .frame(width: 72, height: 72)
            Image(systemName: "trash.fill")
              .font(.system(size: 30))
              .foregroundColor(.red)
          }
          .padding(.top, 8)

          // MARK: – Texto
          VStack(spacing: 8) {
            Text("Deletar conta")
              .font(.grandstander(fontStyle: .title2, fontWeight: .semibold))

            Text("Esta ação é permanente e não pode ser desfeita. Todos os seus dados serão removidos.")
              .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
          }

          // MARK: – Campo de senha
          CustomTextField(
            text: passwordField.binding,
            placeholder: "Confirme sua senha",
            error: passwordField.error,
            isSecure: true
          )

          // MARK: – Erro da API
          if let error = viewModel.errorMessage {
            Text(error)
              .font(.grandstander(fontStyle: .footnote, fontWeight: .regular))
              .foregroundColor(.red)
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity, alignment: .center)
          }

          // MARK: – Botão destrutivo
          Button {
            Task {
              await viewModel.deleteAccount(password: passwordField.value)
            }
          } label: {
            Group {
              if viewModel.isSaving {
                ProgressView()
                  .tint(.white)
              } else {
                Text("Deletar minha conta")
                  .font(.grandstander(fontStyle: .body, fontWeight: .semibold))
              }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(passwordField.value.isEmpty ? Color.red.opacity(0.4) : Color.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
          }
          .disabled(passwordField.value.isEmpty || viewModel.isSaving)
          .animation(.easeInOut(duration: 0.2), value: passwordField.value.isEmpty)
        }
        .padding(24)
      }
      .navigationTitle("Deletar Conta")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancelar") {
            viewModel.showDeleteAccount = false
          }
          .font(.grandstander(fontStyle: .body, fontWeight: .regular))
          .disabled(viewModel.isSaving)
        }
      }
    }
    .interactiveDismissDisabled(viewModel.isSaving)
    .onDisappear {
      viewModel.errorMessage = nil
    }
  }
}
