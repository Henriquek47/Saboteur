//
//  LogoutButtonView.swift
//  Saboteur
//
//  Created by Henrique Lima on 03/05/26.
//

import SwiftUI

struct LogoutButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("Logout")
                .font(.grandstander(fontStyle: .title3, fontWeight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(100)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    LogoutButtonView(action: {})
        .padding()
        .background(Color.gray.opacity(0.1))
}
