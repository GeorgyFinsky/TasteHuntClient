//
//  CafeControllerDisplayTypeEnum.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 18.03.23.
//

import Foundation

enum CafeControllerDisplayType: Int, Segmentable, CaseIterable {
    case map
    case table
    
    var title: String {
        switch self {
            case .map: return "Map"
            case .table: return "Table"
        }
    }
    
    var index: Int {
        return self.rawValue
    }
    
}
