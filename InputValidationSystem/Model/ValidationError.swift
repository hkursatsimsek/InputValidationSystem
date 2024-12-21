//
//  ValidationError.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 21.12.2024.
//


struct ValidationError: Error {
    var title: String
    var message: String?
    
    static let requiredError = ValidationError(
        title: "Zorunlu Alan",
        message: "Bu alan boş bırakılamaz."
    )
    
    static func emailError(input: String) -> ValidationError {
        return ValidationError(
            title: "Geçersiz Email",
            message: "Girdiğiniz '\(input)' adresi geçersiz. Geçerli bir email formatı kullanın (örnek: example@domain.com)."
        )
    }
    
    static func minLengthError(count: Int) -> ValidationError {
        return ValidationError(
            title: "Şifre Çok Kısa",
            message: "Şifreniz en az \(count) karakter olmalıdır."
        )
    }
    
    static func maxLengthError(count: Int) -> ValidationError {
        return ValidationError(
            title: "Şifre Çok Uzun",
            message: "Şifreniz en fazla \(count) karakter olmalıdır."
        )
    }
}
