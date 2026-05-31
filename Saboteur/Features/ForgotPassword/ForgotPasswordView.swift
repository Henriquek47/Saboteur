//
//  ForgotPasswordView.swift
//  Saboteur
//
//  Created by Henrique Lima on 12/04/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: ForgotPasswordViewModel
    
    init(viewModel: ForgotPasswordViewModel = ForgotPasswordViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.primaryTheme
                .ignoresSafeArea()
            
            VStack {
                CustomAppBar()
                headerSection
                recoveryCard
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerSection: some View {
        VStack(spacing: 2) {
            Text("Recuperar")
                .font(.grandstander(fontStyle: .largeTitle, fontWeight: .bold))
                .padding(.top, 16)
            
            Text("Insira seu email para recuperar a senha")
                .font(.grandstander(fontStyle: .subheadline, fontWeight: .medium)).padding(.top, 4)
        }
    }
    
    private var recoveryCard: some View {
        VStack {
            Text("Esqueci minha senha")
                .font(.grandstander(fontStyle: .title2, fontWeight: .semibold)).padding(.top, 8)
            
            CustomTextField(text: viewModel.email.binding, placeholder: "Seu email", error: viewModel.email.error).padding(.top, 16)
            
            Button(action: {
                router.pop()
            }) {
                Text("Voltar para o login")
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
            
            if let successMessage = viewModel.successMessage, !successMessage.isEmpty {
                Text(successMessage)
                    .font(.grandstander(fontStyle: .footnote, fontWeight: .medium))
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            
            Button(action: {
                Task {
                    await viewModel.sendCode()
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.black)
                } else {
                    Text("Enviar Codigo")
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
        .padding(.top, 16)
    }
}

#Preview {
    ForgotPasswordView().environment(AppRouter())
}
