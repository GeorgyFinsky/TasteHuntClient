//
//  ControllersListEnum.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 11.03.23.
//

import UIKit

enum ControllersList {
    case login
    case registration
    
    var vc: UIViewController {
        switch self {
            case .login:
                return LoginController()
            case .registration:
                return RegistrationController()
        }
    }
}
