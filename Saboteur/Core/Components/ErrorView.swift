//
//  ErrorView.swift
//  Saboteur
//
//  Created by Henrique Lima on 23/05/26.
//

import SwiftUI

struct ErrorView: View {
  var message: String = "Verifique sua conexão com a internet e tente novamente."
  var onRetry: () async -> Void

  @State private var isRetrying = false

  var body: some View {
    ZStack {
      Color.primaryTheme.ignoresSafeArea()

      VStack(spacing: 0) {
        Spacer()

        // Icon + texto
        VStack(spacing: 16) {
          ZStack {
            Circle()
              .fill(Color.black.opacity(0.08))
              .frame(width: 88, height: 88)

            Image(systemName: "wifi.exclamationmark")
              .font(.system(size: 36, weight: .semibold))
              .foregroundColor(.black.opacity(0.65))
          }

          VStack(spacing: 8) {
            Text("Ops, algo deu errado")
              .font(.grandstander(fontStyle: .title2, fontWeight: .bold))
              .foregroundColor(.black)

            Text(message)
              .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
              .foregroundColor(.black.opacity(0.55))
              .multilineTextAlignment(.center)
              .padding(.horizontal, 8)
          }
        }
        .padding(.horizontal, 32)

        Spacer()

        // Botão de retry
        Button {
          Task { await retry() }
        } label: {
          Group {
            if isRetrying {
              ProgressView()
                .progressViewStyle(.circular)
                .tint(.black)
            } else {
              HStack(spacing: 10) {
                Image(systemName: "arrow.clockwise")
                  .font(.system(size: 16, weight: .semibold))
                Text("Tentar novamente")
                  .font(.grandstander(fontStyle: .body, fontWeight: .semibold))
              }
            }
          }
          .frame(maxWidth: .infinity)
          .frame(height: 54)
          .background(Color.black)
          .foregroundColor(.primaryTheme)
          .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
        }
        .disabled(isRetrying)
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
      }
    }
  }

  private func retry() async {
    isRetrying = true
    defer { isRetrying = false }
    await onRetry()
  }
}

#Preview {
  ErrorView {
    try? await Task.sleep(nanoseconds: 1_500_000_000)
  }
}
