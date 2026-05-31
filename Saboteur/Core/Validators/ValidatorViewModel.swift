//
//  ValidatorViewModel.swift
//  Saboteur
//
//  Created by Henrique Lima on 16/03/26.
//
import Observation
import Foundation
import Combine
import SwiftUI

@Observable
class ValidatedField {
    var value: String = "" {
        didSet {
            if value != oldValue {
                validateDebounced()
            }
        }
    }
    
    var binding: Binding<String> {
        Binding(
            get: { self.value },
            set: { self.value = $0 }
        )
    }
    
    var error: String?
    
    private let rules: [AnyValidationRule<String>]
    private var validationTask: Task<Void, Never>?
    
    init(rules: [AnyValidationRule<String>]) {
        self.rules = rules
    }
    
    private func validateDebounced() {
        validationTask?.cancel()
        
        validationTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            
            guard let self, !Task.isCancelled else { return }
            
            await MainActor.run {
                self.error = self.validate(self.value)
            }
        }
    }
    
    private func validate(_ value: String) -> String? {
        for rule in rules {
            if let error = rule.validate(value) {
                return error
            }
        }
        return nil
    }
}
