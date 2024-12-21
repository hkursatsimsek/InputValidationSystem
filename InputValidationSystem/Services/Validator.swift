//
//  Validators.swift
//  InputValidationSystem
//
//  Created by Kürşat Şimşek on 14.12.2024.
//

import Foundation

class Validator {
    private let rules: [ValidationRule]
    
    init(rules: [ValidationRule]) {
        self.rules = rules
    }
    
    func validate(_ value: String) throws {
        for rule in rules {
            try rule.validate(value)
        }
    }
}
