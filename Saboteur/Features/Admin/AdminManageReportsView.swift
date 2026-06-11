//
//  AdminManageReportsView.swift
//  Saboteur
//

import SwiftUI

struct AdminManageReportsView: View {
  @State private var viewModel = AdminReportsViewModel()
  @State private var reportToDelete: ReportModel?

  var body: some View {
    VStack(spacing: 8) {
      CustomAppBar(title: "Gerenciar denúncias")

      content
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(Color(uiColor: .systemGroupedBackground))
    .navigationBarBackButtonHidden()
    .task { await viewModel.refresh() }
    .alert(
      "Excluir denúncia",
      isPresented: Binding(
        get: { reportToDelete != nil },
        set: { if !$0 { reportToDelete = nil } }
      )
    ) {
      Button("Cancelar", role: .cancel) { reportToDelete = nil }
      Button("Excluir", role: .destructive) {
        if let report = reportToDelete {
          Task { await viewModel.deleteReport(id: report.id) }
          reportToDelete = nil
        }
      }
    } message: {
      Text("Tem certeza de que deseja excluir esta denúncia? Essa ação não pode ser desfeita.")
    }
    .toast(message: $viewModel.errorMessage)
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.isLoading && !viewModel.hasLoaded {
      LoadingView(message: "Carregando denúncias...", backgroundColor: .white)
    } else if let errorMessage = viewModel.errorMessage, viewModel.reports.isEmpty {
      errorState(message: errorMessage)
    } else if viewModel.reports.isEmpty {
      emptyState(icon: "exclamationmark.bubble", message: "Nenhuma denúncia no grupo ainda.")
    } else {
      ScrollView {
        LazyVStack(spacing: 16) {
          ForEach(viewModel.reports, id: \.id) { report in
            reportCard(report)
              .onAppear {
                Task { await viewModel.loadMoreIfNeeded(currentReport: report) }
              }
          }
          if viewModel.isLoadingMore {
            ProgressView().frame(maxWidth: .infinity).padding(.vertical, 8)
          }
        }
        .padding(16)
      }
      .refreshable { await viewModel.refresh() }
    }
  }

  private func reportCard(_ report: ReportModel) -> some View {
    VStack(alignment: .leading, spacing: 0) {
      // Imagem full-width
      ImageNetwork(urlString: report.imageUrl, width: .infinity, height: 180, radius: 0)
        .frame(maxWidth: .infinity)
        .frame(height: 180)
        .clipped()
        .allowsHitTesting(false)

      VStack(alignment: .leading, spacing: 12) {
        // Header: denunciado + data
        HStack(alignment: .top) {
          VStack(alignment: .leading, spacing: 4) {
            Text(report.reportedMemberName)
              .font(.grandstander(fontStyle: .headline, fontWeight: .bold))
              .foregroundColor(.primary)

            HStack(spacing: 4) {
              Image(systemName: "person.fill")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
              Text("Por \(report.reportingMemberName)")
                .font(.grandstander(fontStyle: .footnote, fontWeight: .regular))
                .foregroundColor(.secondary)
            }
          }

          Spacer()

          // Badge data
          Text(formattedDate(report.createdAt))
            .font(.grandstander(fontStyle: .caption, fontWeight: .regular))
            .foregroundColor(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(Color(uiColor: .systemGroupedBackground))
            .clipShape(Capsule())
        }

        // Descrição
        Text(report.description)
          .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
          .foregroundColor(.primary.opacity(0.8))
          .lineLimit(3)

        Divider()

        // Botão excluir
        Button {
          reportToDelete = report
        } label: {
          HStack(spacing: 6) {
            Image(systemName: "trash")
              .font(.system(size: 13, weight: .semibold))
            Text("Excluir denúncia")
              .font(.grandstander(fontStyle: .subheadline, fontWeight: .semibold))
          }
          .foregroundColor(.red)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
      }
      .padding(16)
    }
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    .shadow(color: .black.opacity(0.07), radius: 10, x: 0, y: 4)
  }

  private func emptyState(icon: String, message: String) -> some View {
    VStack(spacing: 12) {
      Image(systemName: icon)
        .font(.system(size: 40))
        .foregroundColor(.secondary)
      Text(message)
        .font(.grandstander(fontStyle: .body, fontWeight: .regular))
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(24)
  }

  private func errorState(message: String) -> some View {
    VStack(spacing: 16) {
      Text(message)
        .font(.grandstander(fontStyle: .body, fontWeight: .regular))
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
      Button("Tentar novamente") {
        Task { await viewModel.refresh() }
      }
      .font(.grandstander(fontStyle: .body, fontWeight: .semibold))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(24)
  }

  private func formattedDate(_ raw: String) -> String {
    let iso = ISO8601DateFormatter()
    iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    guard let date = iso.date(from: raw) else { return raw }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "pt_BR")
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter.string(from: date)
  }
}

#Preview {
  AdminManageReportsView()
    .environment(AppRouter())
}
