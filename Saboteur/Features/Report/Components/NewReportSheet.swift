//
//  NewReportSheet.swift
//  Saboteur
//
//  Created by Henrique Lima on 24/05/26.
//

import SwiftUI

struct NewReportSheet: View {
  @Environment(\.dismiss) private var dismiss
  @Bindable var viewModel: ReportViewModel

  @State private var selectedMemberId: String? = nil
  @State private var selectedScale: CGFloat = 1.0
  @State private var selectedImage: UIImage? = nil
  @State private var isShowingImagePicker = false
  @FocusState private var isDescriptionFocused: Bool
  @State private var description: ValidatedField = ValidatedField(rules: [
    AnyValidationRule(NonEmptyRule(message: "Descrição é obrigatória"))
  ])

  var selectableMembers: [MemberModel] {
    viewModel.members.filter { $0.userId != viewModel.currentUserId }
  }

  var body: some View {
    NavigationStack {
      ScrollView(showsIndicators: false) {
        VStack(spacing: 24) {

          // MARK: - Description Header
          VStack(alignment: .leading, spacing: 8) {
            Text("Selecione um participante")
              .font(.grandstander(fontStyle: .headline, fontWeight: .bold))
              .foregroundStyle(.white)

            Text("Quem você gostaria de denunciar? A denúncia é totalmente anônima.")
              .font(.grandstander(fontStyle: .subheadline, fontWeight: .regular))
              .foregroundStyle(.white.opacity(0.6))
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 20)
          .padding(.top, 12)

          // MARK: - Participants List
          if selectableMembers.isEmpty {
            VStack(spacing: 12) {
              Image(systemName: "person.3.sequence.fill")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.3))

              Text("Nenhum outro participante encontrado")
                .font(.grandstander(fontStyle: .subheadline, fontWeight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
            .background(
              RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.04))
            )
            .padding(.horizontal, 20)
          } else {
            VStack(spacing: 12) {
              ForEach(selectableMembers) { user in
                let isSelected = user.userId == selectedMemberId
                let rank =
                  (viewModel.members.firstIndex(where: { $0.userId == user.userId }) ?? 0) + 1

                Button {
                  withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    selectedMemberId = user.userId
                  }
                } label: {
                  HStack(spacing: 12) {
                    // Indice / Rank
                    Text("#\(rank)")
                      .font(.grandstander(fontStyle: .title3, fontWeight: .bold))
                      .foregroundStyle(isSelected ? .white : .white.opacity(0.7))

                    // Avatar
                    ImageNetwork(urlString: user.photoUrl, width: 44, height: 44, radius: 22)

                    // Informações do participante
                    VStack(alignment: .leading, spacing: 4) {
                      Text(user.name)
                        .font(.grandstander(fontStyle: .title3, fontWeight: .bold))
                        .foregroundStyle(.white)

                      Text("\(user.score) pontos")
                        .font(.grandstander(fontStyle: .callout, fontWeight: .medium))
                        .foregroundStyle(isSelected ? .white.opacity(0.8) : .white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Indicador de seleção
                    ZStack {
                      Circle()
                        .stroke(
                          isSelected ? Color.accentRed : Color.white.opacity(0.3), lineWidth: 2
                        )
                        .frame(width: 22, height: 22)

                      if isSelected {
                        Circle()
                          .fill(Color.accentRed)
                          .frame(width: 12, height: 12)
                      }
                    }
                  }
                  .padding(16)
                  .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                      .fill(isSelected ? Color.accentRed.opacity(0.12) : Color.white.opacity(0.05))
                  )
                  .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                      .stroke(
                        isSelected ? Color.accentRed : Color.white.opacity(0.1),
                        lineWidth: isSelected ? 2 : 1)
                  )
                }
                .buttonStyle(.plain)
              }
            }
            .padding(.horizontal, 20)
          }

          // MARK: - Description Input
          VStack(alignment: .leading, spacing: 10) {
            Text("Sobre a denúncia")
              .font(.grandstander(fontStyle: .headline, fontWeight: .bold))
              .foregroundStyle(.white)
              .padding(.horizontal, 20)

            CustomTextField(
              text: description.binding,
              placeholder: "Escreva aqui o que o participante fez de suspeito...",
              error: description.error,
              isDark: true,
              axis: .vertical
            )
            .lineLimit(4...8)
            .focused($isDescriptionFocused)
            .padding(.horizontal, 20)
          }
          .padding(.top, 8)

          // MARK: - Photo Section
          VStack(alignment: .leading, spacing: 10) {
            Text("Foto da prova")
              .font(.grandstander(fontStyle: .headline, fontWeight: .bold))
              .foregroundStyle(.white)
              .padding(.horizontal, 20)

            if let selectedImage = selectedImage {
              ZStack(alignment: .topTrailing) {
                Image(uiImage: selectedImage)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(maxWidth: .infinity)
                  .frame(height: 200)
                  .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                  .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                      .stroke(.white.opacity(0.15), lineWidth: 1)
                  )

                Button {
                  self.selectedImage = nil
                } label: {
                  Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(.white, Color.accentRed)
                    .padding(8)
                }
              }
              .padding(.horizontal, 20)
            } else {
              Button {
                isShowingImagePicker = true
              } label: {
                HStack(spacing: 12) {
                  ZStack {
                    Circle()
                      .fill(.white.opacity(0.08))
                      .frame(width: 44, height: 44)
                    Image(systemName: "camera.fill")
                      .font(.system(size: 18, weight: .semibold))
                      .foregroundStyle(Color.accentRed)
                  }

                  Text("Tirar foto com a câmera")
                    .font(.grandstander(fontStyle: .subheadline, fontWeight: .bold))
                    .foregroundStyle(.white)

                  Spacer()

                  Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.leading, 8)
                .padding(.trailing, 20)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                  RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.white.opacity(0.05))
                )
                .overlay(
                  RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
              }
              .buttonStyle(.plain)
              .padding(.horizontal, 20)
            }
          }
          .padding(.top, 8)

          // MARK: - Submit Button
          Button {
            guard let selectedId = selectedMemberId else { return }
            Task {
              let success = await viewModel.sendReport(
                reportedMemberId: selectedId,
                description: description.value,
                image: selectedImage
              )
              if success {
                dismiss()
              }
            }
          } label: {
            HStack(spacing: 12) {
              if viewModel.isSendingReport {
                ProgressView()
                  .tint(.white)
              } else {
                Text("Enviar denúncia")
                  .font(.grandstander(fontStyle: .headline, fontWeight: .bold))
                  .foregroundStyle(.white)

                Image(systemName: "paperplane.fill")
                  .font(.system(size: 16, weight: .bold))
                  .foregroundStyle(.white)
              }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background {
              if isFormValid {
                Color.accentRedGradient
              } else {
                Color.white.opacity(0.1)
              }
            }
            .clipShape(Capsule())
            .shadow(
              color: isFormValid ? Color.accentRed.opacity(0.4) : Color.clear,
              radius: 12, x: 0, y: 6
            )
          }
          .disabled(!isFormValid || viewModel.isSendingReport)
          .padding(.horizontal, 20)
          .padding(.top, 12)
          .padding(.bottom, 32)
        }
      }
      .scrollDismissesKeyboard(.interactively)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(
        Color.darkBackgroundGradient
          .ignoresSafeArea()
          .onTapGesture {
            isDescriptionFocused = false
          }
      )
      .navigationTitle("Nova Denúncia")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancelar") {
            dismiss()
          }
          .font(.grandstander(fontStyle: .body, fontWeight: .semibold))
          .foregroundStyle(.white.opacity(0.8))
        }

        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Concluído") {
            isDescriptionFocused = false
          }
          .font(.grandstander(fontStyle: .body, fontWeight: .bold))
          .foregroundStyle(Color.accentRed)
          .padding(.vertical, 8)
          .padding(.trailing, 8)
        }
      }
      .toolbarColorScheme(.dark, for: .navigationBar)
      .sheet(isPresented: $isShowingImagePicker) {
        ImagePicker(image: $selectedImage, sourceType: .camera)
      }
    }
  }

  private var isFormValid: Bool {
    selectedMemberId != nil
      && !description.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && description.error == nil
      && selectedImage != nil
  }
}

#Preview {
  NewReportSheet(viewModel: ReportViewModel())
}
