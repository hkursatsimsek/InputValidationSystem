//
//  RegisterViewModel.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 14.12.2024.
//

import Foundation

class RegisterViewModel {
    
    var email = ""
    var password = ""
    var confirmPassword = ""
    var username = ""
    var phoneNumber = ""
    
    func validateFields() -> ValidationError? {
        let usernameValidator = Validator(rules: [RequiredRule()])
        if case let .failure(error) = ValidationService.shared.validate(username, using: usernameValidator) {
            debugPrint("Username Validation Error: \(error)")
            return error
        }
        
        let emailValidator = Validator(rules: [RequiredRule(), EmailRule()])
        if case let .failure(error) = ValidationService.shared.validate(email, using: emailValidator) {
            debugPrint("Email Validation Error: \(error)")
            return error
        }

        let phoneValidator = Validator(rules: [RequiredRule(), PhoneRule()])
        if case let .failure(error) = ValidationService.shared.validate(phoneNumber, using: phoneValidator) {
            debugPrint("Phone Validation Error: \(error)")
            return error
        }

        let passwordValidator = Validator(rules: [
            RequiredRule(),
            MinLengthRule(minLength: 8),
            UppercaseRule(),
            LowercaseRule(),
            SpecialCharacterRule()
        ])
        if case let .failure(error) = ValidationService.shared.validate(password, using: passwordValidator) {
            debugPrint("Password Validation Error: \(error)")
            return error
        }
        
        if password != confirmPassword {
            let mismatchError = ValidationError(title: "Şifre Hatası", message: "Şifreler eşleşmiyor.")
            debugPrint("Confirm Password Validation Error: \(mismatchError)")
            return mismatchError
        }
        
        return nil
    }
}
