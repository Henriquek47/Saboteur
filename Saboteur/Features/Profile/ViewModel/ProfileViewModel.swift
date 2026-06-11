//
//  ProfileViewModel.swift
//  Saboteur
//
//  Created by Henrique Lima on 19/05/26.
//

import Factory
import FirebaseAuth
import Foundation
import Observation

@Observable
class ProfileViewModel {
  @Injected(\.authManager) @ObservationIgnored private var authManager
  @Injected(\.userRepository) @ObservationIgnored private var userRepository
  @Injected(\.authRepository) @ObservationIgnored private var authRepository
  @Injected(\.groupManager) @ObservationIgnored private var groupManager

  var userProfileDto: UserMemberDto?

  var hasGroup: Bool {
    groupManager.hasGroup
  }

  var userPhotoUrl: String? {
    userProfileDto?.user.profileImageUrl ?? authManager.user?.photoURL?.absoluteString
  }

  var userName: String {
    userProfileDto?.user.name ?? authManager.user?.displayName ?? "Usuário"
  }

  var currentUserId: String? {
    authManager.user?.uid
  }

  var isCurrentUserAdmin: Bool {
    guard let group = groupManager.group, let userId = currentUserId else { return false }
    return group.adminMemberUserId == userId
  }

  var score: Int {
    userProfileDto?.member?.score ?? 0
  }

  var isLoading: Bool = false
  var showEditProfile: Bool = false
  var showEditPassword: Bool = false
  var showDeleteAccount: Bool = false
  var isSaving: Bool = false
  var isLeavingGroup: Bool = false
  var errorMessage: String? = nil

  func loadUserProfile() async {
    isLoading = true
    defer { isLoading = false }
    do {
      userProfileDto = try await userRepository.getMe()
    } catch {
      print("Failed to load user profile: \(error)")
    }
  }

  func updateProfile(name: String, photoUrl: String?) async {
    isSaving = true
    errorMessage = nil
    defer { isSaving = false }
    do {
      let updatedUser = try await userRepository.updateMe(
        name: name.isEmpty ? nil : name,
        photoUrl: photoUrl
      )
      // Reflect changes locally without a full reload
      if let dto = userProfileDto {
        let newUser = UserModel(
          uid: dto.user.uid,
          name: updatedUser.name,
          email: dto.user.email,
          profileImageUrl: updatedUser.profileImageUrl
        )
        userProfileDto = UserMemberDto(user: newUser, member: dto.member)
      } else {
        await loadUserProfile()
      }
      showEditProfile = false
    } catch {
      errorMessage = "Falha ao salvar. Tente novamente."
    }
  }

  func updatePassword(currentPassword: String, newPassword: String) async {
    isSaving = true
    errorMessage = nil
    defer { isSaving = false }
    do {
      try await authRepository.updatePassword(
        currentPassword: currentPassword, newPassword: newPassword)
      showEditPassword = false
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func deleteAccount(password: String) async {
    isSaving = true
    errorMessage = nil
    defer { isSaving = false }
    do {
      try await authRepository.deleteAccount(password: password)
      showDeleteAccount = false
    } catch {
      errorMessage = error.localizedDescription
    }
  }

  func leaveGroup() async {
    isLeavingGroup = true
    errorMessage = nil
    defer { isLeavingGroup = false }
    do {
      try await groupManager.leaveGroup()
      if let dto = userProfileDto {
        userProfileDto = UserMemberDto(user: dto.user, member: nil)
      }
    } catch {
      errorMessage = "Falha ao sair do grupo. Tente novamente."
    }
  }

  func signOut() throws {
    try authManager.signOut()
  }
}
