//
//  ApiClient.swift
//  Saboteur
//
//  Created by Henrique Lima on 17/03/26.
//

import FirebaseAuth
import Foundation

class ApiClient {

  private let baseURL = "http://192.168.1.104:8000"

  nonisolated init() {}

  private func createRequest(endpoint: String, method: String, body: Data? = nil) async throws
    -> URLRequest
  {
    guard let url = URL(string: "\(baseURL)\(endpoint)") else {
      throw ApiClientError.invalidURL
    }

    var request = URLRequest(url: url)
    request.httpMethod = method
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpBody = body

    // Se houver um usuário autenticado no Firebase, insere o token no cabeçalho
    if let currentUser = Auth.auth().currentUser {
      do {
        let token = try await currentUser.getIDToken()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      } catch {
        print("Error getting Firebase ID Token in ApiClient: \(error)")
      }
    }

    return request
  }

  // Executa a requisição e decodifica o JSON de resposta
  private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
    let data: Data
    let response: URLResponse
    do {
      (data, response) = try await URLSession.shared.data(for: request)
    } catch {
      throw ApiClientError.networkError
    }

    guard let httpResponse = response as? HTTPURLResponse else {
      throw ApiClientError.unknownError
    }

    guard (200...299).contains(httpResponse.statusCode) else {
      if let apiError = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
        throw ApiClientError.apiError(apiError.error)
      }
      throw ApiClientError.requestFailed(httpResponse.statusCode)
    }

    do {
      let decodedData = try JSONDecoder().decode(T.self, from: data)
      return decodedData
    } catch {
      throw ApiClientError.decodingError
    }
  }

  // MARK: - Métodos HTTP

  /// GET Request
  func get<T: Decodable>(endpoint: String) async throws -> T {
    let request = try await createRequest(endpoint: endpoint, method: "GET")
    return try await performRequest(request)
  }

  /// POST Request com corpo
  func post<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
    guard let bodyData = try? JSONEncoder().encode(body) else {
      throw ApiClientError.encodingError
    }
    let request = try await createRequest(endpoint: endpoint, method: "POST", body: bodyData)
    return try await performRequest(request)
  }

  /// POST Request sem corpo
  func post<T: Decodable>(endpoint: String) async throws -> T {
    let request = try await createRequest(endpoint: endpoint, method: "POST")
    return try await performRequest(request)
  }

  /// PUT Request
  func put<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
    guard let bodyData = try? JSONEncoder().encode(body) else {
      throw ApiClientError.encodingError
    }
    let request = try await createRequest(endpoint: endpoint, method: "PUT", body: bodyData)
    return try await performRequest(request)
  }

  /// PATCH Request
  func patch<T: Decodable, U: Encodable>(endpoint: String, body: U) async throws -> T {
    guard let bodyData = try? JSONEncoder().encode(body) else {
      throw ApiClientError.encodingError
    }
    let request = try await createRequest(endpoint: endpoint, method: "PATCH", body: bodyData)
    return try await performRequest(request)
  }

  /// DELETE Request (geralmente não retorna corpo, apenas status)
  func delete(endpoint: String) async throws {
    let request = try await createRequest(endpoint: endpoint, method: "DELETE")
    let data: Data
    let response: URLResponse
    do {
      (data, response) = try await URLSession.shared.data(for: request)
    } catch {
      throw ApiClientError.networkError
    }

    guard let httpResponse = response as? HTTPURLResponse else {
      throw ApiClientError.unknownError
    }

    guard (200...299).contains(httpResponse.statusCode) else {
      if let apiError = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
        throw ApiClientError.apiError(apiError.error)
      }
      throw ApiClientError.requestFailed(httpResponse.statusCode)
    }
  }
}
