//
//  ValidationService.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 14.12.2024.
//

import Foundation

class ValidationService {
    static let shared = ValidationService()
    private init() {}
    
    func validate(_ value: String, with validator: Validator) -> ValidationResult {
        return validator.validate(value)
    }
}
