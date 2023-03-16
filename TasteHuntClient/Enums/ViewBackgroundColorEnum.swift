//
//  ViewBackgroundColorEnum.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 11.03.23.
//

import UIKit

enum BackgroundType {
    case gray
    case clear
    case red
    case green
    
    var color: UIColor {
        switch self {
            case .gray:     return .systemGray6
            case .clear:    return .clear
            case .red:      return .red
            case .green:    return .green
        }
    }
    
}
