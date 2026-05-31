//
//  nonce.swift
//  Saboteur
//
//  Created by Henrique Lima on 07/04/26.
//

import Security
import CryptoKit
import Foundation

// Função auxiliar para gerar o Nonce aleatório
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
        fatalError("Incapaz de gerar nonce aleatório")
    }

    let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    let nonce = randomBytes.map { byte in
        charset[Int(byte) % charset.count]
    }

    return String(nonce)
}

// Função para fazer o Hash SHA256 (é o que você envia para a Apple)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()

    return hashString
}
