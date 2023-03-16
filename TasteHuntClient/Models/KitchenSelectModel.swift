//
//  KitchenSelectModel.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 14.03.23.
//

import Foundation

struct KitchenSelectModel: Decodable {
    var imageUrl: String = ""
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "imageUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
    }
    
}
