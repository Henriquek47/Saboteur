//
//  SignInView.swift
//  Saboteur
//
//  Created by Henrique Lima on 01/04/26.
//

import SwiftUI

struct SignInView: View {
  @Environment(AppRouter.self) private var router
  @State private var viewModel = SignInViewModel()

  var body: some View {
    ZStack {
      Color.primaryTheme
        .ignoresSafeArea()

      VStack {
        headerSection
        loginCard
        othersLoginMethods
      }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .navigationBarBackButtonHidden(true)
  }

  private var headerSection: some View {
    VStack(spacing: 2) {
      Text("Bem-Vindo")
        .font(.grandstander(fontStyle: .largeTitle, fontWeight: .bold))
        .foregroundColor(.black)

      Text("Comece a organização agora")
        .font(.grandstander(fontStyle: .subheadline, fontWeight: .medium))
        .foregroundColor(.black)
        .padding(.top, 4)
        .padding(.bottom, 40)
    }
  }

  private var othersLoginMethods: some View {
    VStack {
      HStack {
        Rectangle()
          .fill(Color.gray)
          .frame(height: 3)

        Text("Ou")
          .font(.grandstander(fontStyle: .title3, fontWeight: .regular))
          .foregroundColor(.black)
          .padding(.horizontal, 8)

        Rectangle()
          .fill(Color.gray)
          .frame(height: 3)
      }.padding(.horizontal, 16)

      HStack(spacing: 16) {
        socialButton(icon: "google_icon") {
          Task {
            await viewModel.signInWithGoogle()
          }
        }
        socialButton(icon: "apple_icon") {}
      }.padding(
        .vertical, 16
      )
    }
  }

  private func socialButton(icon: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Image(icon)
        .resizable()
        .scaledToFit()
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .frame(height: 50)
        .background(Color.white)
        .cornerRadius(12)
    }
  }

  private var loginCard: some View {
    VStack {
      Text("Login")
        .font(.grandstander(fontStyle: .title2, fontWeight: .semibold))
        .foregroundColor(.black)
        .padding(.top, 16)

      CustomTextField(
        text: viewModel.email.binding, placeholder: "Seu email", error: viewModel.email.error)
      CustomTextField(
        text: viewModel.password.binding, placeholder: "Senha", error: viewModel.password.error,
        isSecure: true)
      Button(action: {
        router.navigate(to: .forgotPassword)
      }) {
        Text("Esqueci minha senha")
          .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
          .foregroundColor(.black)
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
          .padding(.top, 16)
      }

      Button(action: {
        Task {
          await viewModel.signIn()
        }
      }) {
        if viewModel.isLoading {
          ProgressView()
            .tint(.black)
        } else {
          Text("Entrar")
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
      .padding(.top, 24).padding(.bottom, 16)

      Button(action: {
        router.replaceAll(with: .signUp)
      }) {

        Text("Registrar-se")
          .font(.grandstander(fontStyle: .title3, fontWeight: .semibold))
          .foregroundColor(.black)

      }
      .disabled(viewModel.isLoading)
      .frame(maxWidth: .infinity)
      .padding()
      .foregroundColor(.white)
      .cornerRadius(100)
      .padding(.bottom, 16)

    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(.white, in: .rect(cornerRadius: 28))
    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
    .padding()
  }
}

#Preview {
  SignInView().environment(AppRouter())
}
