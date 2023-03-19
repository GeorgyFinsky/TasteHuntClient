//
//  VisitModel.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 19.03.23.
//

import Foundation

struct VisitModel: Decodable {
    var id: UUID = UUID()
    var guestsID: String = ""
    var cafeID: String = ""
    var date: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case guestsID = "guestsID"
        case cafeID = "cafeID"
        case date = "date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        guestsID = try container.decode(String.self, forKey: .guestsID)
        cafeID = try container.decode(String.self, forKey: .cafeID)
        date = try container.decode(String.self, forKey: .date)
    }
    
}
