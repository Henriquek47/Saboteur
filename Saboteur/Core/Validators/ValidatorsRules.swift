//
//  validator_rule.swift
//  Saboteur
//
//  Created by Henrique Lima on 16/03/26.
//

protocol ValidationRule {
  associatedtype Value
  func validate(_ value: Value) -> String?
}

struct AnyValidationRule<Value>: ValidationRule {
  private let _validate: (Value) -> String?

  init<R: ValidationRule>(_ rule: R) where R.Value == Value {
    _validate = rule.validate
  }

  func validate(_ value: Value) -> String? {
    _validate(value)
  }
}

// Regras comuns
struct NonEmptyRule: ValidationRule {
  let message: String
  func validate(_ value: String) -> String? {
    value.isEmpty ? message : nil
  }
}

struct EmailRule: ValidationRule {
  let message = "Email inválido"

  func validate(_ value: String) -> String? {
    let regex = /(?i)^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/
    return value.wholeMatch(of: regex) == nil ? message : nil
  }
}

struct MinLengthRule: ValidationRule {
  let min: Int
  let message: String
  func validate(_ value: String) -> String? {
    value.count < min ? message : nil
  }
}

struct ConfirmPasswordRule: ValidationRule {
  typealias Value = String

  let passwordProvider: () -> String
  let message: String

  func validate(_ value: String) -> String? {
    let currentPassword = passwordProvider()
    return value == currentPassword ? nil : message
  }
}
