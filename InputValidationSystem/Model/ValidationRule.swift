//
//  ValidationRule.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 21.12.2024.
//

import UIKit

protocol ValidationRule {
    func validate(_ value: String) throws
}

struct RequiredRule: ValidationRule {
    func validate(_ value: String) throws {
        if value.isEmpty {
            throw ValidationError.requiredError
        }
    }
}

struct EmailRule: ValidationRule {
    func validate(_ value: String) throws {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: value) {
            throw ValidationError.emailError(input: value)
        }
    }
}

struct PhoneRule: ValidationRule {
    func validate(_ value: String) throws {
        if value.isEmpty {
            throw ValidationError.requiredError
        }

        let phoneRegex = "^[0-9]{10,15}$" // 10 ila 15 rakam
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phoneTest.evaluate(with: value) {
            throw ValidationError(
                title: "Geçersiz Telefon Numarası",
                message: "Telefon numarası yalnızca 10-15 arası rakamlardan oluşmalıdır."
            )
        }
    }
}

struct MinLengthRule: ValidationRule {
    let minLength: Int
    
    func validate(_ value: String) throws {
        if value.count < minLength {
            throw ValidationError.minLengthError(count: minLength)
        }
    }
}

struct MaxLengthRule: ValidationRule {
    let maxLength: Int
    
    func validate(_ value: String) throws {
        if value.count > maxLength {
            throw ValidationError.maxLengthError(count: maxLength)
        }
    }
}

struct UppercaseRule: ValidationRule {
    func validate(_ value: String) throws {
        let uppercaseRegex = ".*[A-Z]+.*"
        let uppercaseTest = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        if !uppercaseTest.evaluate(with: value) {
            throw ValidationError(
                title: "Şifre Hatası",
                message: "Şifreniz en az bir büyük harf içermelidir."
            )
        }
    }
}

struct LowercaseRule: ValidationRule {
    func validate(_ value: String) throws {
        let lowercaseRegex = ".*[a-z]+.*"
        let lowercaseTest = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex)
        if !lowercaseTest.evaluate(with: value) {
            throw ValidationError(
                title: "Şifre Hatası",
                message: "Şifreniz en az bir küçük harf içermelidir."
            )
        }
    }
}

struct SpecialCharacterRule: ValidationRule {
    func validate(_ value: String) throws {
        let specialCharacterRegex = ".*[!@#$%^&*(),.?\":{}|<>]+.*" // En az bir özel karakter içerir
        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        if !specialCharacterTest.evaluate(with: value) {
            throw ValidationError(
                title: "Şifre Hatası",
                message: "Şifreniz en az bir özel karakter içermelidir (!@#$ gibi)."
            )
        }
    }
}
