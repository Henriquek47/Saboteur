//
//  AppFont.swift
//  Saboteur
//
//  Created by Henrique Lima on 07/03/26.
//

import SwiftUI

extension Font {
  static func grandstander(fontStyle: Font.TextStyle = .body, fontWeight: Weight = .regular) -> Font
  {
    return Font.custom(CustomFont(weight: fontWeight).rawValue, size: fontStyle.size, )
  }
}

extension Font.TextStyle {
  var size: CGFloat {
    switch self {
    case .largeTitle: return 34
    case .title: return 28
    case .title2: return 22
    case .title3: return 20
    case .headline: return 17
    case .body: return 17
    case .callout: return 16
    case .subheadline: return 15
    case .footnote: return 13
    case .caption: return 12
    case .caption2: return 11
    @unknown default: return 17
    }
  }
}

enum CustomFont: String {
  case regular = "Grandstander-Regular"
  case semiBold = "Grandstander-SemiBold"
  case bold = "Grandstander-Bold"
  case light = "Grandstander-Light"

  init(weight: Font.Weight) {
    switch weight {
    case .regular:
      self = .regular
    case .semibold:
      self = .semiBold
    case .bold:
      self = .bold
    case .light:
      self = .light
    default:
      self = .regular
    }
  }

}
