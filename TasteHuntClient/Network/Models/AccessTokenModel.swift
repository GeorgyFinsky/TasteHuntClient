//
//  AccessTokenModel.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import Foundation

struct AccessTokenModel: Decodable {
    var token: String = ""
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
    }
    
}
