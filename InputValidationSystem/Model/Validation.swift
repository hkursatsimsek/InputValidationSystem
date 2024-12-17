//
//  Validation.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 14.12.2024.
//

import Foundation

enum ValidationResult {
    case success
    case failure(String)
}

protocol Validator {
    func validate(_ value: String) -> ValidationResult
}
