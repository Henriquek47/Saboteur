//
//  AuthRepository.swift
//  Saboteur
//
//  Created by Henrique Lima on 17/03/26.
//

import FirebaseAuth
import Foundation

class AuthRepository {
  private let firebaseClient: FirebaseClient
  private let googleClient: GoogleClient
  private let storageService: UserStorageService
  private let apiClient: ApiClient

  nonisolated init(
    firebaseClient: FirebaseClient,
    googleClient: GoogleClient,
    storageService: UserStorageService,
    apiClient: ApiClient
  ) {
    self.firebaseClient = firebaseClient
    self.googleClient = googleClient
    self.storageService = storageService
    self.apiClient = apiClient
  }

  func signUp(name: String, email: String, password: String, imageUrl: String) async throws {
    guard let url = URL(string: imageUrl) else {
      throw ApiClientError.invalidImageUrl
    }
    let (imageData, _) = try await URLSession.shared.data(from: url)

    try await firebaseClient.createUser(
      name: name, email: email, password: password, profileImageData: imageData)

    let photoUrl = Auth.auth().currentUser?.photoURL?.absoluteString
    var requestBody: [String: String] = [:]
    requestBody["name"] = name
    if let photoUrl = photoUrl {
      requestBody["photo_url"] = photoUrl
    }

    try await registerAndSaveUser {
      try await self.apiClient.post(endpoint: "/users/register", body: requestBody)
    }
  }

  func signIn(email: String, password: String) async throws {
    try await firebaseClient.signInUser(email: email, password: password)
    try await registerAndSaveUser {
      try await self.apiClient.post(endpoint: "/users/register")
    }
  }

  @MainActor
  func signInGoogle() async throws {
    let googleReponse = try await googleClient.signIn()

    try await firebaseClient.signInWithGoogle(
      idToken: googleReponse.idToken, accessToken: googleReponse.accessToken)

    let currentUser = Auth.auth().currentUser
    let name = currentUser?.displayName ?? "Usuário Google"
    let photoUrl = currentUser?.photoURL?.absoluteString

    var requestBody: [String: String] = [:]
    requestBody["name"] = name
    if let photoUrl = photoUrl {
      requestBody["photo_url"] = photoUrl
    }

    try await registerAndSaveUser {
      try await self.apiClient.post(endpoint: "/users/register", body: requestBody)
    }
  }

  func resetPassword(email: String) async throws {
    try await firebaseClient.resetPassword(email: email)
  }

  func updatePassword(currentPassword: String, newPassword: String) async throws {
    try await firebaseClient.updatePassword(currentPassword: currentPassword, newPassword: newPassword)
  }

  func deleteAccount(password: String) async throws {
    // 1. Remove os dados do backend
    try await apiClient.delete(endpoint: "/users/me")
    // 2. Deleta a conta no Firebase (inclui re-autenticação)
    try await firebaseClient.deleteAccount(password: password)
    // 3. Limpa storage local
    storageService.clear()
  }

  private func registerAndSaveUser(_ action: () async throws -> UserModel) async throws {
    do {
      let user = try await action()
      storageService.saveUser(user)
    } catch {
      try? Auth.auth().signOut()
      storageService.clear()
      throw error
    }
  }
}
