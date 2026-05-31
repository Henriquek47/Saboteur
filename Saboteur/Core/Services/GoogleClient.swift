//
//  GoogleSignInHelper.swift
//  Saboteur
//
//  Created by Henrique Lima on 08/04/26.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleResultTokens {
    let accessToken: String
    let idToken: String
    let email: String
}

class GoogleClient{
    
    @MainActor
    func signIn() async throws -> GoogleResultTokens {
        guard let topViewController = UtilViewController.share.getTopViewController() else{
            throw GoogleClientError.noTopViewController
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topViewController);
        guard let idToken = result.user.idToken?.tokenString else {
            throw GoogleClientError.noIdToken
        }
        let accessToken = result.user.accessToken.tokenString
        let email = result.user.profile?.email ?? ""
        return GoogleResultTokens(accessToken: accessToken, idToken: idToken, email: email)
    }
}
