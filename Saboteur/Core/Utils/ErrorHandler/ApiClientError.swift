//
//  ApiClientError.swift
//  Saboteur
//
//  Created by Henrique Lima on 23/03/26.
//

import Foundation

public struct ApiErrorResponse: Codable {
  public let error: ApiErrorDetail
}

public struct ApiErrorDetail: Codable {
  public let code: String
  public let message: String
  public let statusCode: Int
  public let details: [String: String]?

  enum CodingKeys: String, CodingKey {
    case code
    case message
    case statusCode = "status_code"
    case details
  }

  public var errorCode: BackendErrorCode {
    BackendErrorCode(rawValue: code) ?? .unknown
  }
}

public enum BackendErrorCode: String, Codable {
  case invalidToken = "INVALID_TOKEN"
  case badRequest = "BAD_REQUEST"
  case emailRequired = "EMAIL_REQUIRED"
  case unknown
}

enum ApiClientError: Error, LocalizedError {
  case invalidURL
  case requestFailed(Int)
  case decodingError
  case encodingError
  case unknownError
  case invalidImageUrl
  case apiError(ApiErrorDetail)
  case networkError

  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "URL inválida. Verifique o endereço e tente novamente."

    case .requestFailed:
      return "Não foi possível completar a requisição. Tente novamente mais tarde."

    case .decodingError:
      return "Erro ao interpretar a resposta do servidor."

    case .encodingError:
      return "Erro ao preparar os dados para envio."

    case .unknownError:
      return "Erro inesperado. Tente novamente."

    case .invalidImageUrl:
      return "URL da imagem inválida ou não encontrada."

    case .apiError(let detail):
      return detail.message

    case .networkError:
      return "Não foi possível conectar ao servidor. Verifique sua conexão e tente novamente."
    }
  }
}
