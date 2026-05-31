//
//  InfoCardView.swift
//  Saboteur
//
//  Created by Henrique Lima on 03/05/26.
//

import SwiftUI

struct InfoCardView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.grandstander(fontStyle: .body, fontWeight: .semibold))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
                
            Spacer(minLength: 0)
            
            Text(value)
                .font(.grandstander(fontStyle: .title, fontWeight: .bold))
                .foregroundColor(.black)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .padding(12)
        .background(color)
        .cornerRadius(20)
    }
}

#Preview {
    HStack(spacing: 12) {
        InfoCardView(title: "Pontos totais", value: "12", color: .primaryTheme)
        InfoCardView(title: "Denuncias feitas", value: "8", color: .red)
        InfoCardView(title: "Denuncias realizadas", value: "3", color: .gray)
    }
    .padding()
}
