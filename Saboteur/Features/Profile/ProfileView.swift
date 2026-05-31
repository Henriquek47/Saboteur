//
//  ProfileView.swift
//  Saboteur
//
//  Created by Henrique Lima on 19/05/26.
//

import SwiftUI

struct ProfileView: View {
  @State private var viewModel = ProfileViewModel()
  @State private var showSignOutAlert = false
  @State private var showLeaveGroupAlert = false
  @Environment(AppRouter.self) private var router

  var body: some View {
    ZStack {
      VStack(spacing: 12) {
        VStack(spacing: 12) {
          ZStack {
            Text("Perfil")
              .font(.grandstander(fontStyle: .headline, fontWeight: .semibold))
              .frame(maxWidth: .infinity, alignment: .center)

            HStack {
              Spacer()
              Button {
                viewModel.showEditProfile = true
              } label: {
                Image(systemName: "square.and.pencil")
                  .font(.headline)
                  .foregroundColor(.black)
              }
              .opacity(viewModel.isLoading ? 0.5 : 1.0)
              .disabled(viewModel.isLoading)
            }
          }
          ImageNetwork(urlString: viewModel.userPhotoUrl, width: 80, height: 80)

          Text(viewModel.userName)
            .font(.grandstander(fontStyle: .title, fontWeight: .semibold))
            .multilineTextAlignment(.center)
          Text("\(viewModel.score) Pontos")
            .font(.grandstander(fontStyle: .headline, fontWeight: .semibold))
            .shimmer(isActive: viewModel.isLoading)
        }
        .padding(16)

        ScrollView {
          VStack(spacing: 20) {

            ProfileOptionRow(iconName: "lock", title: "Editar senha", iconBgColor: .orange) {
              viewModel.showEditPassword = true
            }

            ProfileOptionRow(
              iconName: "exclamationmark.bubble", title: "Histórico de denúncias",
              iconBgColor: .purple
            ) {
              // Ação de ver histórico
            }

            ProfileOptionRow(iconName: "trash", title: "Deletar conta", iconBgColor: .red) {
              viewModel.showDeleteAccount = true
            }

            ProfileOptionRow(
              iconName: "doc.text", title: "Termos de uso e Políticas", iconBgColor: .teal
            ) {
              router.navigate(to: .termsOfUse)
            }

            if viewModel.hasGroup {
              ProfileOptionRow(
                iconName: "person.2.slash", title: "Sair do grupo", iconBgColor: .orange
              ) {
                showLeaveGroupAlert = true
              }
            }

            ProfileOptionRow(
              iconName: "rectangle.portrait.and.arrow.forward", title: "Sair", iconBgColor: .gray
            ) {
              showSignOutAlert = true
            }
          }
          .padding(24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .white))
        .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: -6)
      }
      .background(Color(uiColor: .primaryTheme))
      .ignoresSafeArea(edges: .bottom)

      if viewModel.isLeavingGroup {
        LoadingView(message: "Saindo do grupo...")
      }
    }
    .task {
      await viewModel.loadUserProfile()
    }
    .sheet(isPresented: $viewModel.showEditProfile) {
      EditProfileView(viewModel: viewModel)
        .presentationDetents([.fraction(0.55)])
    }
    .sheet(isPresented: $viewModel.showEditPassword) {
      EditPasswordView(viewModel: viewModel)
        .presentationDetents([.medium])
    }
    .sheet(isPresented: $viewModel.showDeleteAccount) {
      DeleteAccountView(viewModel: viewModel)
        .presentationDetents([.medium])
    }
    .alert("Sair da Conta", isPresented: $showSignOutAlert) {
      Button("Cancelar", role: .cancel) {}
      Button("Sair", role: .destructive) {
        try? viewModel.signOut()
      }
    } message: {
      Text("Tem certeza de que deseja sair da sua conta?")
    }
    .alert("Sair do Grupo", isPresented: $showLeaveGroupAlert) {
      Button("Cancelar", role: .cancel) {}
      Button("Sair", role: .destructive) {
        Task { await viewModel.leaveGroup() }
      }
    } message: {
      Text("Tem certeza de que deseja sair deste grupo?")
    }
    .toast(message: $viewModel.errorMessage)
  }
}

#Preview {
  ProfileView().environment(AppRouter())
}
