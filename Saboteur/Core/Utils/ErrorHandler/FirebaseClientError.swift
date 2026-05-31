//  FirebaseClientError.swift
//  Saboteur
//
//  Created by Henrique Lima on 20/03/26.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation

enum FirebaseClientError: Error, LocalizedError {
  // MARK: - Auth (Sign Up & Sign In)
  case invalidCredential
  case emailAlreadyInUse
  case invalidEmail
  case weakPassword
  case wrongPassword
  case userNotFound
  case userDisabled
  case tooManyRequests
  case operationNotAllowed

  // Profile
  case profileUpdateFailed

  // Firestore
  case permissionDenied
  case databaseError

  // 📦 Storage
  case storageUploadFailed
  case storageUnauthorized
  case imageCorrupted

  // Gerais
  case networkError
  case unknown(Error)

  // MARK: - LocalizedError

  var errorDescription: String? {
    switch self {
    // Auth
    case .invalidCredential, .wrongPassword:
      return "E-mail ou senha incorretos. Verifique seus dados e tente novamente."
    case .emailAlreadyInUse:
      return "Este e-mail já está em uso. Tente fazer login ou use outro e-mail."
    case .invalidEmail:
      return "O e-mail informado não é válido."
    case .weakPassword:
      return "A senha é muito fraca. Use pelo menos 6 caracteres."
    case .userNotFound:
      return "Não encontramos nenhuma conta com este e-mail."
    case .userDisabled:
      return "Esta conta foi desativada por um administrador."
    case .tooManyRequests:
      return "Muitas tentativas bloqueadas. Tente novamente mais tarde."
    case .operationNotAllowed:
      return "O cadastro com e-mail e senha não está habilitado."

    // Profile
    case .profileUpdateFailed:
      return "Não foi possível atualizar o perfil. Tente novamente."

    // Firestore
    case .permissionDenied:
      return "Você não tem permissão para realizar esta ação."
    case .databaseError:
      return "Erro ao acessar o banco de dados. Tente novamente."

    // Storage
    case .storageUploadFailed:
      return "Falha ao enviar o arquivo. Verifique sua conexão."
    case .storageUnauthorized:
      return "Você precisa estar autenticado para enviar arquivos."
    case .imageCorrupted:
      return "A imagem está corrompida ou não é suportada."

    // Gerais
    case .networkError:
      return "Sem conexão com a internet. Verifique sua rede."
    case .unknown(let error):
      return "Erro inesperado: \(error.localizedDescription)"
    }
  }

  // MARK: - Inicializador

  init(_ error: Error) {
    let nsError = error as NSError

    if nsError.domain == AuthErrorDomain,
      let errorCode = AuthErrorCode(rawValue: nsError.code),
      let authError = FirebaseClientError.mapAuthError(errorCode)
    {
      self = authError
      return
    }

    self = FirebaseClientError.mapGeneralError(nsError, originalError: error)
  }

  private static func mapAuthError(_ errorCode: AuthErrorCode) -> FirebaseClientError? {
    switch errorCode {
    case .invalidCredential:
      return .invalidCredential
    case .emailAlreadyInUse:
      return .emailAlreadyInUse
    case .invalidEmail:
      return .invalidEmail
    case .weakPassword:
      return .weakPassword
    case .wrongPassword:
      return .wrongPassword
    case .userNotFound:
      return .userNotFound
    case .userDisabled:
      return .userDisabled
    case .tooManyRequests:
      return .tooManyRequests
    case .operationNotAllowed:
      return .operationNotAllowed
    default:
      return nil
    }
  }

  private static func mapGeneralError(_ nsError: NSError, originalError: Error)
    -> FirebaseClientError
  {
    switch nsError.code {
    case FirestoreErrorCode.permissionDenied.rawValue:
      return .permissionDenied

    case StorageErrorCode.unauthenticated.rawValue,
      StorageErrorCode.unauthorized.rawValue:
      return .storageUnauthorized

    case StorageErrorCode.retryLimitExceeded.rawValue:
      return .storageUploadFailed

    case NSURLErrorNotConnectedToInternet,
      NSURLErrorTimedOut,
      NSURLErrorNetworkConnectionLost:
      return .networkError

    default:
      return .unknown(originalError)
    }
  }
}
