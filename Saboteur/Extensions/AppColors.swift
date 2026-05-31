//
//  AppColors.swift
//  Saboteur
//
//  Created by Henrique Lima on 24/05/26.
//

import SwiftUI

extension Color {

  // MARK: - Theme Colors (Assets)
  // primaryTheme, redTheme, redLightTheme, greenTheme
  // já definidas em Colors.xcassets

  // MARK: - Dark Theme

  /// Fundo escuro principal (tom roxo-escuro)
  static let darkBackground = Color(red: 0.12, green: 0.10, blue: 0.14)

  /// Fundo escuro secundário (tom vinho-escuro)
  static let darkBackgroundSecondary = Color(red: 0.18, green: 0.12, blue: 0.16)

  /// Fundo escuro terciário
  static let darkBackgroundTertiary = Color(red: 0.14, green: 0.10, blue: 0.12)

  /// Fundo da tab bar no modo escuro
  static let darkSurface = Color(red: 0.16, green: 0.14, blue: 0.18)

  // MARK: - Accent Colors

  /// Vermelho escuro para botões e destaques
  static let accentRed = Color(red: 0.72, green: 0.22, blue: 0.22)

  /// Vermelho claro para gradientes de botão
  static let accentRedLight = Color(red: 0.85, green: 0.30, blue: 0.30)

  /// Verde escuro para botões e destaques
  static let accentGreen = Color(red: 0.18, green: 0.55, blue: 0.48)

  /// Verde claro para gradientes de botão
  static let accentGreenLight = Color(red: 0.25, green: 0.65, blue: 0.56)

  // MARK: - Gradients

  /// Gradiente do fundo escuro da tela de denúncia
  static let darkBackgroundGradient = LinearGradient(
    colors: [.darkBackground, .darkBackgroundSecondary, .darkBackgroundTertiary],
    startPoint: .top,
    endPoint: .bottom
  )

  /// Gradiente do botão CTA vermelho
  static let accentRedGradient = LinearGradient(
    colors: [.accentRed, .accentRedLight],
    startPoint: .leading,
    endPoint: .trailing
  )

  /// Gradiente do botão CTA verde
  static let accentGreenGradient = LinearGradient(
    colors: [.accentGreen, .accentGreenLight],
    startPoint: .leading,
    endPoint: .trailing
  )
}
