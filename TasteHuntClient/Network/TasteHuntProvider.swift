//
//  TasteHuntProvider.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import Foundation
import Moya

typealias ArrayResponce<T: Decodable> = (([T]) -> Void)
typealias ObjectResponce<T: Decodable> = ((T) -> Void)
typealias Error = ((String) -> Void)

final class TasteHuntProvider {
    private let provider = MoyaProvider<TasteHuntAPI>(plugins: [NetworkLoggerPlugin()])
    
    func isUsernameExist(username: String, success: @escaping ObjectResponce<NameExistingModel>, failure: @escaping Error) {
        provider.request(.isUsernameExist(username: username)) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode(NameExistingModel.self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func registerGuest(id: UUID, username: String, password: String, profileImageURL: String, kitchens: String, visits: String, success: @escaping ObjectResponce<GuestPublicModel>, failure: @escaping Error) {
        provider.request(.registrateGuest(
            id: id,
            username: username,
            password: password,
            profileImageURL: profileImageURL,
            kitchens: kitchens,
            visits: visits)
        ) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode(GuestPublicModel.self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func loginUser(username: String, password: String, success: @escaping ObjectResponce<AccessTokenModel>, failure: @escaping Error) {
        provider.request(.login(
            username: username,
            password: password)
        ) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode(AccessTokenModel.self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func addKitchen(kitchen: String, success: @escaping ObjectResponce<GuestPublicModel>, failure: @escaping Error) {
        provider.request(.addKitchens(kitchens: kitchen)) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode(GuestPublicModel.self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    
}
