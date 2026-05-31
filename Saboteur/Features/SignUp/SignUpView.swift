//
//  ContentView.swift
//  Saboteur
//
//  Created by Henrique Lima on 12/02/26.
//

import SwiftUI

struct SignUpView: View {
  @Environment(AppRouter.self) private var router
  @State private var viewModel = SignUpViewModel()

  var body: some View {
    ZStack {
      Color.primaryTheme
        .ignoresSafeArea()

      VStack {
        headerSection
        Spacer()
        loginCard
        Spacer()
      }
    }
    .navigationBarBackButtonHidden(true)
  }
  private var headerSection: some View {
    VStack(spacing: 2) {
      Text("Bem-Vindo")
        .font(.grandstander(fontStyle: .largeTitle, fontWeight: .bold))
        .foregroundColor(.black)
        .padding(.top, 40)

      Text("Comece a organização agora")
        .font(.grandstander(fontStyle: .subheadline, fontWeight: .medium))
        .foregroundColor(.black)
        .padding(.top, 4)
    }
  }

  private var loginCard: some View {
    VStack {
      Text("Criar conta")
        .font(.grandstander(fontStyle: .title2, fontWeight: .semibold))
        .foregroundColor(.black)

      CustomCarousel(
        selection: $viewModel.activeIndex, data: viewModel.imageUrls,
        initialIndex: 1
      ).padding(.top, 16)
      CustomTextField(
        text: viewModel.name.binding, placeholder: "Seu nome", error: viewModel.name.error
      ).padding(.top, 16)
      CustomTextField(
        text: viewModel.email.binding, placeholder: "Seu email", error: viewModel.email.error)
      CustomTextField(
        text: viewModel.password.binding, placeholder: "Senha", error: viewModel.password.error,
        isSecure: true)
      CustomTextField(
        text: viewModel.confirmPassword.binding, placeholder: "Confirmar senha",
        error: viewModel.confirmPassword.error, isSecure: true)
      Button(action: {
        router.pop()
      }) {
        Text("Ja tenho conta")
          .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
          .underline()
      }
      .foregroundColor(.primary)
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.top, 16)

      if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
        Text(errorMessage)
          .font(.grandstander(fontStyle: .footnote, fontWeight: .medium))
          .foregroundColor(.red)
          .multilineTextAlignment(.center)
          .padding(.top, 8)
      }

      Button(action: {
        Task {
          await viewModel.signUp()
        }
      }) {
        if viewModel.isLoading {
          ProgressView()
            .tint(.black)
        } else {
          Text("Criar conta")
            .font(.grandstander(fontStyle: .title3, fontWeight: .semibold))
            .foregroundColor(.black)
        }
      }
      .disabled(viewModel.isLoading)
      .frame(maxWidth: .infinity)
      .padding()
      .background(Color.primaryTheme)
      .foregroundColor(.white)
      .cornerRadius(100)
      .padding(.top, 16).padding(.bottom, 16)

    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(.white, in: .rect(cornerRadius: 28))
    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
    .padding()
  }
}

#Preview {
  SignUpView().environment(AppRouter())
}
