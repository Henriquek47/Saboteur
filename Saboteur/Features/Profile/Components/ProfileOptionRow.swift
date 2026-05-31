//
//  ProfileOptionRow.swift
//  Saboteur
//
//  Created by Henrique Lima on 19/05/26.
//

import SwiftUI

struct ProfileOptionRow: View {
  let iconName: String
  let title: String
  let iconBgColor: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 14) {
        HStack(spacing: 16) {
          Image(systemName: iconName)
            .font(.title3)
            .foregroundColor(.black)
            .frame(width: 40, height: 40, alignment: .center)
            .background(iconBgColor)
            .clipShape(Circle())

          Text(title)
            .font(.grandstander(fontStyle: .title3, fontWeight: .semibold))
            .foregroundColor(.black)

          Spacer()

          Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.gray.opacity(0.6))
        }
        .padding(.horizontal, 4)

        Divider()
          .background(Color.gray.opacity(0.15))
      }
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  VStack(spacing: 20) {
    ProfileOptionRow(iconName: "person.fill", title: "Editar Dados", iconBgColor: .blue) {}
    ProfileOptionRow(iconName: "bell.fill", title: "Notificações", iconBgColor: .green) {}
  }
  .padding()
}
