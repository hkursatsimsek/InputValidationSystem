//
//  Validators.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 14.12.2024.
//

import Foundation

// Kullanıcı Adı Validator
class UsernameValidator: Validator {
    func validate(_ value: String) -> ValidationResult {
        return !value.isEmpty ? .success : .failure("Kullanıcı adı boş olamaz.")
    }
}

// Email Validator
class EmailValidator: Validator {
    func validate(_ value: String) -> ValidationResult {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: value) ? .success : .failure("Geçersiz email adresi.")
    }
}

// Telefon Numarası Validator
class PhoneValidator: Validator {
    func validate(_ value: String) -> ValidationResult {
        let phoneRegEx = "^[0-9]{10,15}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: value) ? .success : .failure("Geçersiz telefon numarası.")
    }
}

// Şifre Validator
class PasswordValidator: Validator {
    func validate(_ value: String) -> ValidationResult {
        guard value.count >= 8 else {
            return .failure("Şifre en az 8 karakter olmalı.")
        }
        
        let uppercasePattern = ".*[A-Z]+.*"
        let uppercaseTest = NSPredicate(format: "SELF MATCHES %@", uppercasePattern)
        guard uppercaseTest.evaluate(with: value) else {
            return .failure("Şifre en az 1 büyük harf içermeli.")
        }
        
        let lowercasePattern = ".*[a-z]+.*"
        let lowercaseTest = NSPredicate(format: "SELF MATCHES %@", lowercasePattern)
        guard lowercaseTest.evaluate(with: value) else {
            return .failure("Şifre en az 1 küçük harf içermeli.")
        }
        
        let specialCharacterPattern = ".*[!@#$%^&*(),.?\":{}|<>]+.*"
        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterPattern)
        guard specialCharacterTest.evaluate(with: value) else {
            return .failure("Şifre en az 1 özel karakter içermeli.")
        }
        
        return .success
    }
}

// Şifre Tekrar Validator
class ConfirmPasswordValidator: Validator {
    private let originalPassword: String
    
    init(originalPassword: String) {
        self.originalPassword = originalPassword
    }
    
    func validate(_ value: String) -> ValidationResult {
        return value == originalPassword ? .success : .failure("Şifreler eşleşmiyor.")
    }
}
