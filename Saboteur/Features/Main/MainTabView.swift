//
//  MainTabView.swift
//  Saboteur
//
//  Created by Henrique Lima on 03/05/26.
//

import SwiftUI

struct MainTabView: View {
  @State private var selectedTab: Int = 0
  @State private var viewModel = MainTabViewModel()

  var body: some View {
    Group {
      if viewModel.groupManager.isLoading {
        LoadingView()
      } else if viewModel.groupManager.hasError {
        ErrorView {
          await viewModel.groupManager.loadGroup()
        }
      } else {
        mainContent
      }
    }
    .task {
      await viewModel.groupManager.loadGroup()
    }
  }

  // MARK: – Main content

  private var mainContent: some View {
    Group {
      switch selectedTab {
      case 0:
        if viewModel.groupManager.hasGroup {
          HomeView()
        } else {
          GroupSetupView()
        }
      case 1:
        ReportView()
      case 2:
        TaskView()
      default:
        ProfileView()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .safeAreaInset(edge: .bottom) {
      customBottomBar
    }
    .ignoresSafeArea(.keyboard)
  }

  // MARK: – Bottom bar

  private var isDarkTab: Bool { selectedTab == 1 || selectedTab == 2 }

  private var darkTabAccentColor: Color {
    selectedTab == 1 ? Color.accentRed : Color.accentGreen
  }

  private var darkTabThemeColor: Color {
    selectedTab == 1 ? Color.redTheme : Color.greenTheme
  }

  private var customBottomBar: some View {
    HStack(spacing: 4) {
      tabItem(index: 0, icon: "house.fill", text: nil, enabled: true)
      tabItem(index: 1, icon: nil, text: "Denunciar", enabled: viewModel.groupManager.hasGroup)
      tabItem(index: 2, icon: nil, text: "Tarefas", enabled: viewModel.groupManager.hasGroup)
      tabItem(index: 3, icon: nil, text: "Perfil", enabled: true)
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 10)
    .background(isDarkTab ? Color.darkSurface : .white)
    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
    .shadow(
      color: isDarkTab ? darkTabAccentColor.opacity(0.25) : .black.opacity(0.1),
      radius: 20, x: 0, y: 10
    )
    .padding(.horizontal, 16)
    .padding(.bottom, 8)
    .animation(.easeInOut(duration: 0.3), value: selectedTab)
  }

  private func tabItem(index: Int, icon: String?, text: String?, enabled: Bool) -> some View {
    Button {
      guard enabled else { return }
      withAnimation(.spring()) {
        selectedTab = index
      }
    } label: {
      VStack(spacing: 4) {
        if let icon = icon {
          Image(systemName: icon)
            .font(.system(size: 22, weight: .bold))
        }
        if let text = text {
          Text(text)
            .font(.grandstander(fontStyle: .subheadline, fontWeight: .bold))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.8)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
      .padding(.horizontal, 12)
      .padding(.vertical, 10)
      .frame(minHeight: 44)
      .foregroundColor(
        enabled
          ? (isDarkTab ? .white : .black)
          : (isDarkTab ? .white.opacity(0.25) : .black.opacity(0.25))
      )
      .background(
        selectedTab == index && enabled
          ? (isDarkTab ? darkTabThemeColor : Color.primaryTheme)
          : Color.clear
      )
      .clipShape(Capsule())
    }
    .disabled(!enabled)
  }

  private func contentPlaceholder(title: String) -> some View {
    VStack {
      Text(title)
        .font(.grandstander(fontStyle: .title, fontWeight: .bold))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(uiColor: .systemGroupedBackground))
  }
}

#Preview {
  MainTabView()
    .environment(AppRouter())
}
