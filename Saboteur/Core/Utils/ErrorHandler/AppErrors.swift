//
//  AppErrors.swift
//  Saboteur
//
//  Created by Henrique Lima on 20/03/26.
//
import Foundation

enum AppErrors: Error, LocalizedError {
  case network
  case decoding

  var errorDescription: String? {
    switch self {
    case .network:
      return "Problema de conexão. Verifique sua internet e tente novamente."
    case .decoding:
      return "Erro ao processar os dados recebidos."
    }
  }
}
