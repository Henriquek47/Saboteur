import SwiftUI

struct ReportView: View {
  @Environment(AppRouter.self) private var router
  @State private var viewModel = ReportViewModel()
  @State private var buttonScale: CGFloat = 1.0
  @State private var glowOpacity: Double = 0.4

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 0) {
        // MARK: - Header
        VStack(spacing: 8) {
          Text("Denúncia")
            .font(.grandstander(fontStyle: .largeTitle, fontWeight: .bold))
            .padding(.top, 24)
            .foregroundStyle(.white)

          Text("Tire uma foto e descreva o que aconteceu.\nSua denúncia será anônima.")
            .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
            .foregroundStyle(.white.opacity(0.6))
            .multilineTextAlignment(.center)
            .lineSpacing(4)
        }
        .padding(.bottom, 28)

        // MARK: - Image Section
        ImageNetwork(
          urlString:
            "https://i.pinimg.com/736x/24/b3/f2/24b3f295690363ceb849ff061d9870a7.jpg",
          width: .infinity,
          height: 280,
          radius: 20
        )
        .padding(.horizontal, 20)

        // MARK: - Info Card (Glass)
        VStack(alignment: .leading, spacing: 12) {
          HStack(spacing: 10) {
            Image(systemName: "lightbulb.fill")
              .font(.system(size: 16))
              .foregroundStyle(.yellow)
            Text("Dicas para uma boa denúncia")
              .font(.grandstander(fontStyle: .headline, fontWeight: .semibold))
              .foregroundStyle(.white)
          }

          VStack(alignment: .leading, spacing: 10) {
            tipRow(icon: "camera.fill", text: "Tire uma foto clara do ocorrido")
            tipRow(icon: "text.alignleft", text: "Descreva com detalhes o que viu")
          }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(.white.opacity(0.06))
            .overlay(
              RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.1), lineWidth: 1)
            )
        )
        .padding(.horizontal, 20)
        .padding(.top, 24)

        // MARK: - CTA Button
        Button {
          viewModel.showReportForm = true
        } label: {
          HStack(spacing: 12) {
            ZStack {
              Circle()
                .fill(.white)
                .frame(width: 42, height: 42)
              Image(systemName: "camera.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.accentRed)
            }

            Text("Fazer uma denúncia")
              .font(.grandstander(fontStyle: .headline, fontWeight: .bold))
              .foregroundStyle(.white)

            Spacer()

            Image(systemName: "arrow.right")
              .font(.system(size: 16, weight: .bold))
              .foregroundStyle(.white.opacity(0.7))
          }
          .padding(.leading, 8)
          .padding(.trailing, 20)
          .frame(maxWidth: .infinity)
          .frame(height: 60)
          .background(Color.accentRedGradient)
          .clipShape(Capsule())
          .shadow(
            color: Color.accentRed.opacity(glowOpacity),
            radius: 20, x: 0, y: 8
          )
        }
        .scaleEffect(buttonScale)
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 40)
        .onAppear {
          withAnimation(
            .easeInOut(duration: 2.0)
              .repeatForever(autoreverses: true)
          ) {
            glowOpacity = 0.7
          }
        }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      Color.darkBackgroundGradient
        .ignoresSafeArea()
    )
    .sheet(isPresented: $viewModel.showReportForm) {
      NewReportSheet(viewModel: viewModel)
    }
  }

  // MARK: - Tip Row
  private func tipRow(icon: String, text: String) -> some View {
    HStack(spacing: 12) {
      Image(systemName: icon)
        .font(.system(size: 14))
        .foregroundStyle(Color.redTheme)
        .frame(width: 28, height: 28)
        .background(Color.redTheme.opacity(0.15))
        .clipShape(Circle())

      Text(text)
        .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
        .foregroundStyle(.white.opacity(0.75))
    }
  }
}

#Preview {
  ReportView().environment(AppRouter())
}
