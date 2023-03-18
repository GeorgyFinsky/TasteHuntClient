//
//  CafeModel.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 18.03.23.
//

import Foundation

struct CafeModel: Decodable {
    var id: UUID
    var name: String = ""
    var phone: String = ""
    var profileImageURL: String = ""
    var gpsX: String = ""
    var gpsY: String = ""
    var kitchens: String = ""
    var mondayWorkTime: String = ""
    var thesdayWorkTime: String = ""
    var wednesdayWorkTime: String = ""
    var thusdayWorkTime: String = ""
    var fridayWorkTime: String = ""
    var saturdayWorkTime: String = ""
    var sundayWorkTime: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case phone = "phone"
        case profileImageURL = "profileImageURL"
        case gpsX = "gpsX"
        case gpsY = "gpsY"
        case mondayWorkTime = "mondayWorkTime"
        case thesdayWorkTime = "thesdayWorkTime"
        case wednesdayWorkTime = "wednesdayWorkTime"
        case thusdayWorkTime = "thusdayWorkTime"
        case fridayWorkTime = "fridayWorkTime"
        case saturdayWorkTime = "saturdayWorkTime"
        case sundayWorkTime = "sundayWorkTime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        phone = try container.decode(String.self, forKey: .phone)
        profileImageURL = try container.decode(String.self, forKey: .profileImageURL)
        gpsX = try container.decode(String.self, forKey: .gpsX)
        gpsY = try container.decode(String.self, forKey: .gpsY)
        mondayWorkTime = try container.decode(String.self, forKey: .mondayWorkTime)
        thesdayWorkTime = try container.decode(String.self, forKey: .thesdayWorkTime)
        wednesdayWorkTime = try container.decode(String.self, forKey: .wednesdayWorkTime)
        thusdayWorkTime = try container.decode(String.self, forKey: .thusdayWorkTime)
        fridayWorkTime = try container.decode(String.self, forKey: .fridayWorkTime)
        saturdayWorkTime = try container.decode(String.self, forKey: .saturdayWorkTime)
        sundayWorkTime = try container.decode(String.self, forKey: .sundayWorkTime)
    }
    
}
