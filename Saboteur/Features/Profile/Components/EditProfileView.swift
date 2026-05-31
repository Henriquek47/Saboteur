//
//  EditProfileView.swift
//  Saboteur
//
//  Created by Henrique Lima on 19/05/26.
//

import SwiftUI

struct EditProfileView: View {
  @Bindable var viewModel: ProfileViewModel

  let imageUrls = [
    "https://i.pinimg.com/1200x/2a/0f/6a/2a0f6af09c74817db908b66c022837d9.jpg",
    "https://i.pinimg.com/736x/24/b3/f2/24b3f295690363ceb849ff061d9870a7.jpg",
    "https://i.pinimg.com/736x/eb/40/10/eb40105d5d13f4b728739f107830d035.jpg",
    "https://i.pinimg.com/1200x/c7/04/8d/c7048d0704a8bf3af007c00743bd7c82.jpg",
  ]

  @State private var nameField = ValidatedField(rules: [
    AnyValidationRule(NonEmptyRule(message: "Nome é obrigatório")),
    AnyValidationRule(MinLengthRule(min: 4, message: "Mínimo de 4 caracteres")),
  ])
  @State private var activeIndex: Int? = nil

  var selectedImageUrl: String? {
    guard let index = activeIndex, imageUrls.indices.contains(index) else { return nil }
    return imageUrls[index]
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 32) {

          // MARK: – Avatar carousel
          VStack(spacing: 12) {
            Text("Escolha sua foto")
              .font(.grandstander(fontStyle: .headline, fontWeight: .semibold))
              .frame(maxWidth: .infinity, alignment: .leading)

            CustomCarousel(
              selection: $activeIndex,
              data: imageUrls,
              initialIndex: activeIndex ?? 1
            )
          }

          // MARK: – Name field
          CustomTextField(text: nameField.binding, placeholder: "Seu nome", error: nameField.error)

          // MARK: – Error
          if let error = viewModel.errorMessage {
            Text(error)
              .font(.grandstander(fontStyle: .footnote, fontWeight: .regular))
              .foregroundColor(.red)
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
        .padding(24)
      }
      .navigationTitle("Editar Perfil")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancelar") {
            viewModel.showEditProfile = false
          }
          .font(.grandstander(fontStyle: .body, fontWeight: .regular))
          .disabled(viewModel.isSaving)
        }

        ToolbarItem(placement: .confirmationAction) {
          if viewModel.isSaving {
            ProgressView()
          } else {
            Button("Salvar") {
              Task {
                await viewModel.updateProfile(
                  name: nameField.value,
                  photoUrl: selectedImageUrl
                )
              }
            }
            .font(.grandstander(fontStyle: .body, fontWeight: .semibold))
            .disabled(
              nameField.value.trimmingCharacters(in: .whitespaces).isEmpty || nameField.error != nil
            )
          }
        }
      }
    }
    .onAppear {
      nameField.value = viewModel.userName
      if let currentUrl = viewModel.userPhotoUrl,
        let index = imageUrls.firstIndex(of: currentUrl)
      {
        activeIndex = index
      } else {
        activeIndex = 1
      }
    }
    .interactiveDismissDisabled(viewModel.isSaving)
  }
}
