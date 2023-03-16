//
//  GuestModel.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import Foundation

struct GuestModel: Decodable {
    var id: UUID = UUID()
    var username: String = ""
    var password: String = ""
    var profileImageURL: String = ""
    var kitchens: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case username = "username"
        case password = "password"
        case profileImageURL = "profileImageURL"
        case kitchens = "kitchens"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        username = try container.decode(String.self, forKey: .username)
        password = try container.decode(String.self, forKey: .password)
        profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
        kitchens = try container.decode(String.self, forKey: .kitchens)
    }
    
}
