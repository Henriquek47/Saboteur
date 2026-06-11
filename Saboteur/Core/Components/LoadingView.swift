//
//  LoadingView.swift
//  Saboteur
//
//  Created by Henrique Lima on 23/05/26.
//

import SwiftUI

struct LoadingView: View {
  var message: String = "Carregando..."
  var backgroundColor: Color = .primaryTheme

  var body: some View {
    ZStack {
      backgroundColor.ignoresSafeArea()
      VStack(spacing: 16) {
        ProgressView()
          .progressViewStyle(.circular)
          .scaleEffect(1.4)
          .tint(.black)
        Text(message)
          .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
          .foregroundColor(.black.opacity(0.6))
      }
    }
  }
}

#Preview {
  LoadingView()
}
