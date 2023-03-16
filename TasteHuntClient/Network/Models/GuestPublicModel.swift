//
//  GuestPublicModel.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import Foundation

struct GuestPublicModel: Decodable {
    var username: String = ""
    var profileImageURL: String = ""
//    var kitchens: String = ""
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case profileImageURL = "profileImageURL"
//        case kitchens = "kitchens"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
//        kitchens = try container.decode(String.self, forKey: .kitchens)
    }
    
}
