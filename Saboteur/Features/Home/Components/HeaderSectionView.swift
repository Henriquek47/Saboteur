//
//  HeaderSectionView.swift
//  Saboteur
//
//  Created by Henrique Lima on 03/05/26.
//

import SwiftUI

struct HeaderSectionView: View {
    let userName: String
    let points: Int
    
    var body: some View {
        HStack {
            Text("Hello!\n\(userName)")
                .font(.grandstander(fontStyle: .largeTitle, fontWeight: .bold))
                .padding(.top, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(points) pontos")
                .font(.grandstander(fontStyle: .headline, fontWeight: .bold))
                .foregroundColor(.black)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
                .padding(12)
                .background(Color.primaryTheme)
                .cornerRadius(16)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HeaderSectionView(userName: "Henrique Lima", points: 34)
        .padding()
}
