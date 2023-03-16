//
//  NameExistingModel.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import Foundation

struct NameExistingModel: Decodable {
    var isExist: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case isExist = "isExist"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isExist = try container.decode(String.self, forKey: .isExist)
    }
    
}
