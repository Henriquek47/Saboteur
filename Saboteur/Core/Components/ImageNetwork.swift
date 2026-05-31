//
//  ImageNetwork.swift
//  Saboteur
//
//  Created by Henrique Lima on 19/05/26.
//

import SwiftUI

struct ImageNetwork: View {
  let urlString: String?
  var width: CGFloat = 100
  var height: CGFloat = 100
  var radius: CGFloat = 100

  var body: some View {
    let content = AsyncImage(url: URL(string: urlString ?? "")) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      case .empty:
        if radius >= 100 {
          Circle()
            .fill(Color.gray.opacity(0.2))
            .shimmer()
        } else {
          RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(Color.gray.opacity(0.2))
            .shimmer()
        }
      case .failure:
        Image(systemName: "person.crop.circle.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.gray.opacity(0.3))
      @unknown default:
        EmptyView()
      }
    }
    .frame(width: width, height: height)

    if radius >= 100 {
      content.clipShape(Circle())
    } else {
      content.clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
  }
}

#Preview {
  VStack {
    ImageNetwork(
      urlString: "https://i.pinimg.com/1200x/2a/0f/6a/2a0f6af09c74817db908b66c022837d9.jpg")
    ImageNetwork(urlString: nil)
  }
  .padding()
  .background(Color.white)
}
