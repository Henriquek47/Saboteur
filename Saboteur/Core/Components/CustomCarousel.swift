//
//  CustomCarousel.swift
//  Saboteur
//
//  Created by Henrique Lima on 08/03/26.
//

import SwiftUI

struct CustomCarousel<Data: RandomAccessCollection>: View where Data.Element == String {
  private let itemSize = 100.0
  @State private var currentIndex: Int = 0
  @Binding var selection: Int?

  let data: Data
  let initialIndex: Int

  var body: some View {
    GeometryReader {
      let size = $0.size
      let screenMidX = size.width / 2

      ScrollView(.horizontal) {
        HStack(spacing: 10) {
          ForEach(Array(data.enumerated()), id: \.offset) { index, item in
            avatarImage(url: item, screenMidX: screenMidX).id(index)
          }
        }.scrollTargetLayout()
      }.safeAreaPadding(.horizontal, max(0, (size.width - itemSize) / 2))
        .scrollPosition(id: $selection)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .scrollIndicators(.hidden)
    }
    .frame(height: itemSize)
    .onAppear {
      if selection == nil {
        selection = initialIndex
      }
    }
  }

  private func avatarImage(url: String, screenMidX: CGFloat) -> some View {
    GeometryReader { proxy in
      let midX = proxy.frame(in: .global).midX
      let distance = abs(midX - screenMidX)
      let maxDistance: CGFloat = 150

      let progress = min(distance / maxDistance, 1.0)
      let scale = 1.0 - (0.1 * progress)
      let opacity = 1.0 - (0.5 * progress)

      AsyncImage(url: URL(string: url)) { image in
        image
          .resizable()
          .scaledToFill()
          .frame(width: itemSize, height: itemSize)
          .clipShape(Circle())
      } placeholder: {
        Circle()
          .fill(.gray.opacity(0.5))
          .frame(width: itemSize, height: itemSize)
          .shimmer()
      }
      .scaleEffect(scale)
      .opacity(opacity)
      .frame(width: itemSize, height: itemSize)
    }
    .frame(width: itemSize, height: itemSize)
  }
}
