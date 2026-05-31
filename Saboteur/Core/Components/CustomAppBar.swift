//
//  CustomAppBar.swift
//  Saboteur
//
//  Created by Henrique Lima on 12/04/26.
//

import SwiftUI

struct CustomAppBar: View {
    @Environment(AppRouter.self) private var router
    let title: String?
    
    init(title: String? = nil) {
        self.title = title
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    router.pop()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.black)
                })
                Spacer()
            }
            
            if let title = title {
                Text(title)
                    .font(.grandstander(fontStyle: .title3, fontWeight: .semibold))
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CustomAppBar(title: "Recuperar")
        .environment(AppRouter())
        .background(Color.primaryTheme)
}
