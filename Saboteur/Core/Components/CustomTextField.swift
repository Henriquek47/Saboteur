//
//  CustomTextField.swift
//  Saboteur
//
//  Created by Henrique Lima on 16/03/26.
//

import SwiftUI

struct CustomTextField: View {
  @Binding var text: String
  let placeholder: String
  let error: String?
  var isSecure: Bool = false
  var isDark: Bool = false
  var axis: Axis = .horizontal
  @State private var isPasswordVisible: Bool = false

  var body: some View {
    HStack {
      Group {
        if isSecure && !isPasswordVisible {
          SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(isDark ? .white.opacity(0.4) : .gray))
        } else {
          TextField("", text: $text, prompt: Text(placeholder).foregroundColor(isDark ? .white.opacity(0.4) : .gray), axis: axis)
        }
      }
      .textInputAutocapitalization(.never)
      .foregroundColor(isDark ? .white : .black)

      if isSecure {
        Button(action: {
          isPasswordVisible.toggle()
        }, label: {
          Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
            .foregroundColor(isDark ? .white.opacity(0.6) : .gray)
        })
      }
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(isDark ? Color.white.opacity(0.05) : Color.white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .stroke(isDark ? Color.white.opacity(0.1) : Color.clear, lineWidth: 1)
    )
    .shadow(color: isDark ? Color.clear : Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    .validated(error: error)
    .padding(.top, 8)
  }
}
