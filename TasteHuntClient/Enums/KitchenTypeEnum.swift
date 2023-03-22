//
//  KitchenTypeEnum.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import UIKit

enum KitchensType: String, CaseIterable {
    case asian
    case american
    case belarusian
    case italian
    case french
    case vegetarian
    
    var imageURl: URL {
        switch self {
            case .asian:
                return URL(string: "http://localhost:8080/asian.jpg")!
            case .american:
                return URL(string: "http://localhost:8080/american.jpg")!
            case .belarusian:
                return URL(string: "http://localhost:8080/belarusian.jpg")!
            case .italian:
                return URL(string: "http://localhost:8080/italian.jpg")!
            case .french:
                return URL(string: "http://localhost:8080/french.jpg")!
            case .vegetarian:
                return URL(string: "http://localhost:8080/vegeterian.jpg")!
        }
    }
    
}
