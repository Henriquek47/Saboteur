//
//  Container.swift
//  Saboteur
//
//  Created by Henrique Lima on 22/03/26.
//

import Factory

// Centralizamos todas as dependências aqui
extension Container {

  var apiClient: Factory<ApiClient> {
    self { ApiClient() }.singleton
  }

  var firebaseClient: Factory<FirebaseClient> {
    self { FirebaseClient() }.singleton
  }

  @MainActor
  var googleClient: Factory<GoogleClient> {
    self { @MainActor in GoogleClient() }.singleton
  }

  var userStorageService: Factory<UserStorageService> {
    self { UserStorageService() }.singleton
  }

  @MainActor
  var authManager: Factory<AuthManager> {
    self { @MainActor in
      AuthManager(
        userStorageService: self.userStorageService()
      )
    }.singleton
  }

  @MainActor
  var authRepository: Factory<AuthRepository> {
    self { @MainActor in
      AuthRepository(
        firebaseClient: self.firebaseClient(),
        googleClient: self.googleClient(),
        storageService: self.userStorageService(),
        apiClient: self.apiClient()
      )
    }.singleton
  }

  @MainActor
  var userRepository: Factory<UserRepository> {
    self { @MainActor in
      UserRepository(
        apiClient: self.apiClient()
      )
    }.singleton
  }

  @MainActor
  var groupRepository: Factory<GroupRepository> {
    self { @MainActor in
      GroupRepository(
        apiClient: self.apiClient()
      )
    }.singleton
  }

  @MainActor
  var reportRepository: Factory<ReportRepository> {
    self { @MainActor in
      ReportRepository(
        firebaseClient: self.firebaseClient(),
        apiClient: self.apiClient()
      )
    }.singleton
  }

  @MainActor
  var taskRepository: Factory<TaskRepository> {
    self { @MainActor in
      TaskRepository(
        firebaseClient: self.firebaseClient(),
        apiClient: self.apiClient()
      )
    }.singleton
  }

  @MainActor
  var groupManager: Factory<GroupManager> {
    self { @MainActor in GroupManager() }.singleton
  }
}
