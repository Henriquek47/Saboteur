//
//  ToastModifier.swift
//  Saboteur
//

import SwiftUI

struct ToastModifier: ViewModifier {
  @Binding var message: String?
  var duration: TimeInterval = 3.0

  @State private var dismissWorkItem: DispatchWorkItem?

  func body(content: Content) -> some View {
    ZStack {
      content

      if let message = message {
        VStack {
          HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
              .foregroundColor(.white)
              .font(.title3)

            Text(message)
              .font(.grandstander(fontStyle: .subheadline, fontWeight: .medium))
              .foregroundColor(.white)
              .multilineTextAlignment(.leading)

            Spacer()

            Button {
              withAnimation(.spring()) {
                self.message = nil
              }
            } label: {
              Image(systemName: "xmark")
                .foregroundColor(.white.opacity(0.7))
                .font(.footnote)
            }
          }
          .padding(.horizontal, 16)
          .padding(.vertical, 14)
          .background(Color.black.opacity(0.85))
          .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
          .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 8)
          .padding(.horizontal, 16)
          .padding(.top, 16)

          Spacer()
        }
        .transition(.move(edge: .top).combined(with: .opacity))
        .zIndex(999)
        .onAppear {
          scheduleDismiss()
        }
        .onChange(of: message) { _, _ in
          scheduleDismiss()
        }
      }
    }
  }

  private func scheduleDismiss() {
    dismissWorkItem?.cancel()

    let workItem = DispatchWorkItem {
      withAnimation(.spring()) {
        message = nil
      }
    }

    dismissWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: workItem)
  }
}

extension View {
  func toast(message: Binding<String?>, duration: TimeInterval = 3.0) -> some View {
    self.modifier(ToastModifier(message: message, duration: duration))
  }
}
