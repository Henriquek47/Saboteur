//
//  SignInViewModel.swift
//  Saboteur
//
//  Created by Henrique Lima on 09/03/26.
//

import Observation
import Foundation
import FirebaseAuth
import FirebaseFirestore
import Factory

@Observable
@MainActor
class SignUpViewModel {
    @Injected(\.authRepository) @ObservationIgnored private var authRepository
    
    var name: ValidatedField
    var email: ValidatedField
    var password: ValidatedField
    var confirmPassword: ValidatedField
    
    init( ) {
 
        name = ValidatedField(rules: [
            AnyValidationRule(NonEmptyRule(message: "Nome é obrigatório"))
        ])
        
        email = ValidatedField(rules: [
            AnyValidationRule(NonEmptyRule(message: "Email é obrigatório")),
            AnyValidationRule(EmailRule())
        ])
        
        password = ValidatedField(rules: [
            AnyValidationRule(NonEmptyRule(message: "Senha é obrigatória")),
            AnyValidationRule(MinLengthRule(min: 8, message: "Mínimo 8 caracteres"))
        ])
        
        // Precisamos inicializar confirmPassword DEPOIS de password
        // para poder capturar a referência!
        confirmPassword = ValidatedField(rules: [])
        confirmPassword = ValidatedField(rules: [
            AnyValidationRule(NonEmptyRule(message: "Confirme a senha")),
            AnyValidationRule(
                ConfirmPasswordRule(
                    passwordProvider: { [weak self] in
                        self?.password.value ?? ""
                    },
                    message: "Senhas não coincidem"
                )
            )
        ])
    }
    
    var isLoading = false
    var errorMessage: String? = nil
    
    var canSubmit: Bool {
        let noErrors = name.error == nil
        && email.error == nil
        && password.error == nil
        && confirmPassword.error == nil
        
        let allFilled = !name.value.isEmpty
        && !email.value.isEmpty
        && !password.value.isEmpty
        && !confirmPassword.value.isEmpty
        
        return noErrors && allFilled
    }
    
    var activeIndex: Int? = nil
    
    var imageUrls = ["https://i.pinimg.com/1200x/2a/0f/6a/2a0f6af09c74817db908b66c022837d9.jpg","https://i.pinimg.com/736x/24/b3/f2/24b3f295690363ceb849ff061d9870a7.jpg", "https://i.pinimg.com/736x/eb/40/10/eb40105d5d13f4b728739f107830d035.jpg", "https://i.pinimg.com/1200x/c7/04/8d/c7048d0704a8bf3af007c00743bd7c82.jpg"]
    
    func signUp() async {
        guard canSubmit else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authRepository.signUp(
                name: name.value,
                email: email.value,
                password: password.value,
                imageUrl: imageUrls[activeIndex ?? 0]
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
}
