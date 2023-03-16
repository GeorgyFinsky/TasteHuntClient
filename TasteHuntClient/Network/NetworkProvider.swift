//
//  NetworkProvider.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import Foundation
import Moya

enum TasteHuntAPI {
    case isUsernameExist(username: String)
    case registrateGuest(
        id: UUID,
        username: String,
        password: String,
        profileImageURL: String,
        kitchens: String,
        visits: String
    )
    case addKitchens(kitchens: String)
    case addProfileImage(image: Data)
    case login(
        username: String,
        password: String
    )
    case getAllUsers
}

extension TasteHuntAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://127.0.0.1:8080/")!
    }
    
    var path: String {
        switch self {
            case .isUsernameExist:
                return "users/username"
            case .registrateGuest:
                return "users"
            case .addKitchens:
                return "users/kitchen"
            case .addProfileImage:
                return "users/image"
            case .login:
                return "users/login"
            case .getAllUsers:
                return "users"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .isUsernameExist, .login, .getAllUsers:
                return .get
            case .registrateGuest:
                return .post
            case .addKitchens, .addProfileImage:
                return .put
        }
    }
    
    var headers: [String : String]? {
        switch self {
            case .addKitchens, .addProfileImage:
                guard let token = UserDefaults.standard.object(forKey: "accessToken") as? String else { return nil }
                return ["AccessToken": token]
            default: return nil
        }
    }
    
    var task: Moya.Task {
        guard let parametrs else {
            return .requestPlain
        }
        
        return .requestParameters(parameters: parametrs, encoding: encoding)
    }
    
    var parametrs: [String: Any]? {
        var params = [String: Any]()
        
        switch self {
            case .isUsernameExist(let username):
                params["username"] = username
            case .registrateGuest(
                let id,
                let username,
                let password,
                let profileImageURL,
                let kitchens,
                let visits
            ):
                params["id"] = id
                params["username"] = username
                params["password"] = password
                params["profileImageURL"] = profileImageURL
                params["kitchens"] = kitchens
                params["visits"] = visits
            case .addKitchens(let kitchens):
                params["value"] = kitchens
            case .addProfileImage(let image):
                params["profileImageURL"] = image
            case .login(
                let username,
                let password
            ):
                params["username"] = username
                params["password"] = password
            case .getAllUsers: return nil
        }
        return params
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.prettyPrinted
    }
    
}
