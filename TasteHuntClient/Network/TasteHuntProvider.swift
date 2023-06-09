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
    
    func getAllCafes(success: @escaping ArrayResponce<CafeModel>, failure: @escaping Error) {
        provider.request(.getAllCafes) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode([CafeModel].self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func addProfileImage(image: Data, success: @escaping ObjectResponce<GuestPublicModel>, failure: @escaping Error) {
        provider.request(.addProfileImage(image: image)) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode(GuestPublicModel.self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func getAllUsers(success: @escaping ArrayResponce<GuestModel>, failure: @escaping Error) {
        provider.request(.getAllUsers) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode([GuestModel].self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func createVisit(id: UUID, guestsID: String, cafeID: String, date: String, success: @escaping ObjectResponce<VisitModel>, failure: @escaping Error) {
        provider.request(.createVisit(
            id: id,
            guestsID: guestsID,
            cafeID: cafeID,
            date: date)
        ) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode(VisitModel.self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func getUserVisits(success: @escaping ArrayResponce<VisitModel>, failure: @escaping Error) {
        provider.request(.getUserVisits) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode([VisitModel].self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func getCafe(cafeID: String, success: @escaping ObjectResponce<CafeModel>, failure: @escaping Error) {
        provider.request(.getCafe(cafeID: cafeID)) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode(CafeModel.self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
    func getCafeMenu(cafeID: String, success: @escaping ArrayResponce<DichModel>, failure: @escaping Error) {
        provider.request(.getCafeMenu(cafeID: cafeID)) { result in
            switch result {
                case .success(let responce):
                    guard let result = try? JSONDecoder().decode([DichModel].self, from: responce.data) else { return }
                    success(result)
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
    
}
