//
//  UITextFieldTypeEnum.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 11.03.23.
//

import UIKit

enum TextFieldType {
    case phone
    case email
    case name
    case password
    case none
    
    var validationString: String {
        switch self {
            case .phone:
                return "(\\+375|375)(29|25|44|33)(\\d{3})(\\d{2})(\\d{2})"
            case .email:
                return "[A-z0-9_.+-]+@[A-z0-9-]+(\\.[A-z0-9-]{2,})"
            case .name:
                return "[\\S]{2,16}"
            case .password:
                return "[\\S]{8,25}"
            case .none:
                return "[\\S]"
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
            case .phone:
                return .phonePad
            case .email:
                return .emailAddress
            case .name:
                return .default
            case .password:
                return .default
            case .none:
                return .default
        }
    }
    
    var isAutoCorrectionEnabled: Bool {
        switch self {
            case .phone:
                return false
            case .email:
                return false
            case .name:
                return false
            case .password:
                return false
            case .none:
                return true
        }
    }
    
    var isSecurityEnteryEnabled : Bool {
        switch self {
            case .phone:
                return false
            case .email:
                return false
            case .name:
                return false
            case .password:
                return true
            case .none:
                return false
        }
    }
    
}
