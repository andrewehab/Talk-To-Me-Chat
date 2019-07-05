//
//  String+stringRegEx.swift
//  Music App
//
//  Created by AnDy on 5/3/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import Foundation

extension String {
    
    
    enum validityType {
        case username
        case email
        case password
    }
    
    enum Regex : String {
        case username = "[A-Z0-9a-z]{3,15}"
        case email = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case password = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,25}$"
    }
    
    
    func isValid(validityType : validityType) -> Bool {
        
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validityType {
        case .username:
            regex = Regex.username.rawValue
        case .email:
            regex = Regex.email.rawValue
        case .password:
            regex = Regex.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
