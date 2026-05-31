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
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    Text(error)
                        .font(.grandstander(fontStyle: .footnote, fontWeight: .regular))
                        .foregroundColor(.red)
                }.padding(.top, 6)
            }
        }
    }
}

extension View {
    func validated(error: String?) -> some View {
        modifier(ValidationModifier(error: error))
    }
}
