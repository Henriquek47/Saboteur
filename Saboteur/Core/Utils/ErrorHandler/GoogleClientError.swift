//
//  GoogleClientError.swift
//  Saboteur
//
//  Created by Henrique Lima on 08/04/26.
//

//
//  AppErrors.swift
//  Saboteur
//
//  Created by Henrique Lima on 20/03/26.
//
import Foundation

enum GoogleClientError: Error, LocalizedError {
  case network
  case decoding
  case noTopViewController
  case noIdToken

  var errorDescription: String? {
    switch self {
    case .network:
      return "Problema de conexão. Verifique sua internet e tente novamente."
    case .decoding:
      return "Erro ao processar os dados recebidos."
    case .noTopViewController:
      return "Não foi possível encontrar a tela para apresentar o login."
    case .noIdToken:
      return "Não foi possível obter o token de autenticação do Google."
    }
  }
}
