//
//  RankListView.swift
//  Saboteur
//
//  Created by Henrique Lima on 26/04/26.
//

import SwiftUI

struct RankListView: View {
  let rankList: [MemberModel]
  let currentUserId: String?

  var body: some View {
    VStack(spacing: 8) {
      headerSection

      ForEach(Array(rankList.enumerated()), id: \.element.userId) { index, user in
        let isCurrentUser = user.userId == currentUserId

        rankItem(user: user, index: index, isCurrentUser: isCurrentUser)
      }
    }
  }

  private var headerSection: some View {
    HStack {
      Text("Rank dos participantes")
        .font(.grandstander(fontStyle: .footnote, fontWeight: .semibold))
        .foregroundColor(.black)
      Spacer()
      Button(action: {}) {
        Text("Ver todos")
          .font(.grandstander(fontStyle: .footnote, fontWeight: .semibold))
          .foregroundColor(.black)
          .underline()
      }
    }
  }

  @ViewBuilder
  private func rankItem(user: MemberModel, index: Int, isCurrentUser: Bool) -> some View {
    Button(action: {
      // Ação ao clicar no participante
    }) {
      HStack(spacing: 12) {
        Text("#\(index + 1)")
          .font(.grandstander(fontStyle: .title3, fontWeight: .bold))
          .foregroundColor(.black)

        ImageNetwork(urlString: user.photoUrl, width: 40, height: 40)

        VStack(alignment: .leading, spacing: 4) {
          Text(user.name)
            .font(.grandstander(fontStyle: .title3, fontWeight: .bold))
            .foregroundColor(.black)

          Text("\(user.score) pontos")
            .font(.grandstander(fontStyle: .callout, fontWeight: .medium))
            .foregroundColor(isCurrentUser ? .black : .secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

        Image(systemName: "chevron.right")
          .font(.system(size: 14, weight: .bold))
          .foregroundColor(.black)
      }
      .padding()
      .background(isCurrentUser ? Color.primaryTheme : Color.white)
      .cornerRadius(20)
      .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    .buttonStyle(.plain)
    .padding(.top, 4)
  }
}

#Preview {
  RankListView(
    rankList: [
      MemberModel(
        userId: "1", name: "Henrique",
        score: 100,
        photoUrl: "https://i.pinimg.com/1200x/2a/0f/6a/2a0f6af09c74817db908b66c022837d9.jpg"),
      MemberModel(
        userId: "2", name: "João",
        score: 200,
        photoUrl: "https://i.pinimg.com/736x/24/b3/f2/24b3f295690363ceb849ff061d9870a7.jpg"),
    ],
    currentUserId: "1"
  )
  .padding()
  .background(Color.gray.opacity(0.1))
}
