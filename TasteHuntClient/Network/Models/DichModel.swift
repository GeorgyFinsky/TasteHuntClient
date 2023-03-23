//
//  DichModel.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 23.03.23.
//

import Foundation

struct DichModel: Decodable {
    var id: UUID = UUID()
    var cafeID: String = ""
    var name: String = ""
    var price: String = ""
    var profileImageURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cafeID = "cafeID"
        case name = "name"
        case price = "price"
        case profileImageURL = "profileImageURL"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        cafeID = try container.decode(String.self, forKey: .cafeID)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(String.self, forKey: .price)
        profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
    }
    
}
