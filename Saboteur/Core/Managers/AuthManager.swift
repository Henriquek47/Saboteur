import FirebaseAuth
import SwiftUI

@Observable
class AuthManager {
  private let storageService: UserStorageService

  var user: User?
  var isLoading = true
  var hasLocalUser = false

  var isAuthenticated: Bool { user != nil && hasLocalUser }

  private var handler: AuthStateDidChangeListenerHandle?

  init(userStorageService: UserStorageService) {
    self.storageService = userStorageService
    storageService.onUserSaved = { [weak self] in
      DispatchQueue.main.async { self?.refreshLocalUser() }
    }
    listenToAuthState()
  }

  func listenToAuthState() {
    handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
      DispatchQueue.main.async {
        self?.user = user
        self?.refreshLocalUser()
        self?.isLoading = false
      }
    }
  }

  func refreshLocalUser() {
    hasLocalUser = storageService.fetchUser() != nil
  }

  func signOut() throws {
    do {
      try Auth.auth().signOut()
      storageService.clear()
      hasLocalUser = false
    } catch {
      throw FirebaseClientError(error)
    }
  }

  deinit {
    if let handler = handler {
      Auth.auth().removeStateDidChangeListener(handler)
    }
  }
}
