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
    
    func validateFields() -> String? {
        if case let .failure(message) = ValidationService.shared.validate(username, with: UsernameValidator()) {
            return message
        }
        
        if case let .failure(message) = ValidationService.shared.validate(email, with: EmailValidator()) {
            return message
        }

        if case let .failure(message) = ValidationService.shared.validate(phoneNumber, with: PhoneValidator()) {
            return message
        }

        if case let .failure(message) = ValidationService.shared.validate(password, with: PasswordValidator()) {
            return message
        }
        
        if case let .failure(message) = ValidationService.shared.validate(confirmPassword, with: ConfirmPasswordValidator(originalPassword: password)) {
            return message
        }
        
        return nil
    }
}
