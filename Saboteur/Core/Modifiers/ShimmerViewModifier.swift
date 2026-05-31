//
//  ShimmerViewModifier.swift
//  Saboteur
//
//  Created by Henrique Lima on 08/03/26.
//

import SwiftUI

struct ShimmerViewModifier: ViewModifier {
  let speed: Double
  let color: Color
  let angle: Double
  let animateOpacity: Bool
  let animeteScale: Bool

  @State var move = false

  func body(content: Content) -> some View {
    content.overlay {
      GeometryReader {
        geometry in
        let gradient = LinearGradient(
          colors: [
            color.opacity(0),
            color.opacity(0.5),
            color.opacity(0),
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
        Rectangle().fill(gradient).rotationEffect(
          .degrees(
            angle
          )
        ).frame(
          width: geometry.size.width / 1.5,
          height: geometry.size.height * 2
        ).offset(
          x: move ? geometry.size.width * 1.1 : -geometry.size.width * 1.4,
          y: -geometry.size.height / 2
        ).animation(
          .linear(duration: speed).repeatForever(autoreverses: false),
          value: move
        ).task {
          try? await Task.sleep(nanoseconds: 300_000_000)
          move = true
        }
      }
    }.mask(content)
  }
}

extension View {
  func shimmer(
    isActive: Bool = true,
    speed: Double = 1,
    color: Color = .white,
    angle: Double = 0,
    animateOpacity: Bool = false,
    animateScale: Bool = false
  ) -> some View {
    Group {
      if isActive {
        self.modifier(
          ShimmerViewModifier(
            speed: speed,
            color: color,
            angle: angle,
            animateOpacity: animateScale,
            animeteScale: animateOpacity,
          ))
      } else {
        self
      }
    }
  }
}
