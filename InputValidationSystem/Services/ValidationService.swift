//
//  ValidationService.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 14.12.2024.
//

import UIKit

class ValidationService {
    static let shared = ValidationService()
    private init() {}
    
    func validate(_ value: String, using validator: Validator) -> Result<Void, ValidationError> {
        print("Validating value: \(value)")
        do {
            try validator.validate(value)
            debugPrint("Validation successful for value: \(value)")
            return .success(())
        } catch let error as ValidationError {
            debugPrint("Validation failed for value: \(value) with error: \(error)")
            return .failure(error)
        } catch {
            let unknownError = ValidationError(title: "Bilinmeyen Hata", message: error.localizedDescription)
            debugPrint("Validation failed for value: \(value) with unknown error: \(unknownError)")
            return .failure(unknownError)
        }
    }
}
