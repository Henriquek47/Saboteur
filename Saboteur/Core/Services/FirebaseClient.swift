//  FirebaseClient.swift
//  Saboteur
//
//  Created by Henrique Lima on 17/03/26.
//

import AuthenticationServices
import FirebaseAuth
// import FirebaseFirestore
import FirebaseStorage
import GoogleSignIn

class FirebaseClient {

  nonisolated init() {}

  // MARK: - Email Sign Up & Sign In

  func createUser(name: String, email: String, password: String, profileImageData: Data?)
    async throws
  {
    do {
      let result = try await Auth.auth().createUser(withEmail: email, password: password)
      let uid = result.user.uid
      var photoURL: URL? = nil

      if let imageData = profileImageData {
        photoURL = try await uploadProfileImage(uid: uid, imageData: imageData)
      }

      let changeRequest = result.user.createProfileChangeRequest()
      changeRequest.displayName = name
      changeRequest.photoURL = photoURL
      try await changeRequest.commitChanges()

    } catch {
      throw FirebaseClientError(error)
    }
  }

  func signInUser(email: String, password: String) async throws -> String {
    do {
      let result = try await Auth.auth().signIn(withEmail: email, password: password)
      return result.user.uid
    } catch {
      throw FirebaseClientError(error)
    }
  }

  // MARK: - Google Sign In

  func signInWithGoogle(idToken: String, accessToken: String) async throws -> String {
    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)

    do {
      let result = try await Auth.auth().signIn(with: credential)
      let user = result.user

      return user.uid
    } catch {
      throw FirebaseClientError(error)
    }
  }

  // MARK: - Apple Sign In
  //
  //    func signInWithApple(idToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> String {
  //        let credential = OAuthProvider.appleCredential(
  //            withIDToken: idToken,
  //            rawNonce: rawNonce
  //        )
  //
  //        do {
  //            let result = try await Auth.auth().signIn(with: credential)
  //            let user = result.user
  //
  //            // Se for um novo usuário, salvamos no Firestore
  //            if result.additionalUserInfo?.isNewUser == true {
  //                let name = [fullName?.givenName, fullName?.familyName]
  //                    .compactMap { $0 }
  //                    .joined(separator: " ")
  //
  //                try await saveUserToFirestore(
  //                    uid: user.uid,
  //                    name: name.isEmpty ? (user.displayName ?? "Usuário Apple") : name,
  //                    email: user.email ?? "",
  //                    photoURL: nil // Apple raramente fornece foto de cara
  //                )
  //            }
  //
  //            return user.uid
  //        } catch {
  //            throw FirebaseClientError(error)
  //        }
  //    }
  //

  // MARK: - Storage

  private func uploadProfileImage(uid: String, imageData: Data) async throws -> URL {
    let storageRef = Storage.storage().reference().child("profile_images/\(uid).jpg")
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"

    _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
    return try await storageRef.downloadURL()
  }

  func uploadReportImage(imageData: Data) async throws -> URL {
    let filename = UUID().uuidString
    let storageRef = Storage.storage().reference().child("report_images/\(filename).jpg")
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"

    _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
    return try await storageRef.downloadURL()
  }

  func uploadTaskImage(imageData: Data) async throws -> URL {
    let filename = UUID().uuidString
    let storageRef = Storage.storage().reference().child("task_images/\(filename).jpg")
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"

    _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
    return try await storageRef.downloadURL()
  }

  func resetPassword(email: String) async throws {
    let actionCodeSettings = ActionCodeSettings()
    actionCodeSettings.url = URL(string: "https://saboteur-f0341.firebaseapp.com/reset-password")
    actionCodeSettings.handleCodeInApp = true
    actionCodeSettings.setIOSBundleID("henrique.Saboteur")
    actionCodeSettings.setAndroidPackageName(
      "henrique.Saboteur", installIfNotAvailable: false, minimumVersion: "12")

    do {
      try await Auth.auth().sendPasswordReset(
        withEmail: email, actionCodeSettings: actionCodeSettings)
    } catch {
      throw FirebaseClientError(error)
    }
  }

  func updatePassword(currentPassword: String, newPassword: String) async throws {
    guard let user = Auth.auth().currentUser,
      let email = user.email
    else {
      throw FirebaseClientError.unknown(
        NSError(
          domain: "FirebaseClient", code: -1,
          userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado."]))
    }

    let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

    do {
      try await user.reauthenticate(with: credential)
      try await user.updatePassword(to: newPassword)
    } catch {
      throw FirebaseClientError(error)
    }
  }

  func deleteAccount(password: String) async throws {
    guard let user = Auth.auth().currentUser,
      let email = user.email
    else {
      throw FirebaseClientError.unknown(
        NSError(
          domain: "FirebaseClient", code: -1,
          userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado."]))
    }

    let credential = EmailAuthProvider.credential(withEmail: email, password: password)

    do {
      try await user.reauthenticate(with: credential)
      try await user.delete()
    } catch {
      throw FirebaseClientError(error)
    }
  }
}
