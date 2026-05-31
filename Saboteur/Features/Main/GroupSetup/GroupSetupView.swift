//
//  GroupSetupView.swift
//  Saboteur
//
//  Created by Henrique Lima on 23/05/26.
//

import SwiftUI

struct GroupSetupView: View {
  @State private var viewModel = GroupSetupViewModel()

  var body: some View {
    ZStack {
      Color.primaryTheme
        .ignoresSafeArea()

      VStack(spacing: 8) {

        // MARK: – Header
        VStack(spacing: 8) {
          Image(systemName: "person.3.fill")
            .font(.system(size: 52, weight: .semibold))
            .foregroundColor(.black.opacity(0.75))
            .padding(.bottom, 8)

          Text("Nenhum grupo ainda")
            .font(.grandstander(fontStyle: .title2, fontWeight: .bold))
            .foregroundColor(.black)

          Text("Crie um grupo novo ou entre em um existente usando o código de convite.")
            .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
            .foregroundColor(.black.opacity(0.6))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)
        }
        .padding(.top, 40)
        .padding(.horizontal, 24)

        // MARK: – Card
        VStack(spacing: 16) {

          // Criar grupo
          Button {
            Task { await viewModel.createGroup() }
          } label: {
            Group {
              if viewModel.isCreating {
                ProgressView().tint(.black)
              } else {
                HStack(spacing: 10) {
                  Image(systemName: "plus.circle.fill")
                    .font(.title3)
                  Text("Criar novo grupo")
                    .font(.grandstander(fontStyle: .title3, fontWeight: .semibold))
                }
              }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.primaryTheme)
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
          }
          .disabled(viewModel.isCreating || viewModel.isJoining)

          // Divisor
          HStack {
            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
            Text("ou")
              .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
              .foregroundColor(.secondary)
              .padding(.horizontal, 12)
            Rectangle().fill(Color.gray.opacity(0.3)).frame(height: 1)
          }

          // Entrar com link
          if viewModel.showJoinCard {
            VStack(spacing: 12) {
              CustomTextField(
                text: viewModel.linkField.binding,
                placeholder: "Código do grupo",
                error: viewModel.linkField.error
              )

              Button {
                Task { await viewModel.joinGroup() }
              } label: {
                Group {
                  if viewModel.isJoining {
                    ProgressView().tint(.white)
                  } else {
                    Text("Entrar no grupo")
                      .font(.grandstander(fontStyle: .body, fontWeight: .semibold))
                  }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                  viewModel.linkField.value.count >= 6 ? Color.black : Color.black.opacity(0.3)
                )
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
              }
              .disabled(
                viewModel.linkField.value.count < 6 || viewModel.isJoining || viewModel.isCreating)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
          } else {
            Button {
              withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                viewModel.showJoinCard = true
              }
            } label: {
              HStack(spacing: 10) {
                Image(systemName: "link.badge.plus")
                  .font(.title3)
                Text("Entrar com código")
                  .font(.grandstander(fontStyle: .title3, fontWeight: .semibold))
              }
              .frame(maxWidth: .infinity)
              .frame(height: 54)
              .background(Color.white)
              .foregroundColor(.black)
              .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
              .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 4)
            }
            .disabled(viewModel.isCreating || viewModel.isJoining)
            .transition(.opacity)
          }

          // Erro
          if let error = viewModel.errorMessage {
            Text(error)
              .font(.grandstander(fontStyle: .footnote, fontWeight: .regular))
              .foregroundColor(.red)
              .multilineTextAlignment(.center)
          }
        }
        .padding(24)
        .background(.white, in: .rect(cornerRadius: 32))
        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 24)

      }.frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: .center
      )
    }
  }
}
