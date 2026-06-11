//
//  AdminActionsSectionView.swift
//  Saboteur
//

import SwiftUI

struct AdminActionsSectionView: View {
  let onManageReports: () -> Void
  let onManageTasks: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 6) {
        Image(systemName: "shield.lefthalf.filled")
          .font(.system(size: 12, weight: .semibold))
        Text("Painel do admin")
          .font(.grandstander(fontStyle: .footnote, fontWeight: .semibold))
      }
      .foregroundColor(.black)

      HStack(spacing: 12) {
        adminCard(
          title: "Denúncias",
          subtitle: "Revisar envios",
          icon: "exclamationmark.bubble.fill",
          accentColor: Color.red,
          action: onManageReports
        )

        adminCard(
          title: "Tarefas",
          subtitle: "Aprovar envios",
          icon: "checkmark.circle.fill",
          accentColor: Color.accentGreen,
          action: onManageTasks
        )
      }
    }
  }

  private func adminCard(
    title: String,
    subtitle: String,
    icon: String,
    accentColor: Color,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: 14) {
        HStack {
          Image(systemName: icon)
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(accentColor)
            .frame(width: 36, height: 36)
            .background(accentColor.opacity(0.12))
            .clipShape(Circle())

          Spacer()

          Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.black.opacity(0.35))
        }

        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(.grandstander(fontStyle: .headline, fontWeight: .bold))
            .foregroundColor(.black)

          Text(subtitle)
            .font(.grandstander(fontStyle: .caption, fontWeight: .regular))
            .foregroundColor(.secondary)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
        }
      }
      .padding(16)
      .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
      .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  AdminActionsSectionView(onManageReports: {}, onManageTasks: {})
    .padding()
    .background(Color(uiColor: .systemGroupedBackground))
}
