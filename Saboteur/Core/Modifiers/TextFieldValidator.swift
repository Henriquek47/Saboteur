//
//  TextFieldValidator.swift
//  Saboteur
//
//  Created by Henrique Lima on 16/03/26.
//

import SwiftUI

struct ValidationModifier: ViewModifier {
  let error: String?

  func body(content: Content) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      content
        .background(
          RoundedRectangle(cornerRadius: 16)
            .stroke(error != nil ? Color.red : Color.clear, lineWidth: 2)
        )

      if let error = error, !error.isEmpty {
        HStack(alignment: .top, spacing: 4) {
          Image(systemName: "exclamationmark.circle.fill")
            .foregroundColor(.red)
            .font(.footnote)
            .padding(.top, 1)
          Text(error)
            .font(.grandstander(fontStyle: .footnote, fontWeight: .regular))
            .foregroundColor(.red)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, 6)
      }
    }
  }
}

extension View {
  func validated(error: String?) -> some View {
    modifier(ValidationModifier(error: error))
  }
}
