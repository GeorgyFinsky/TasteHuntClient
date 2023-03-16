//
//  Environment.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 11.03.23.
//

import UIKit

struct Environment {
    // Environment.sceneDelegate?.setTabbarAsInitial()
    static var sceneDelegate: SceneDelegate? {
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        return scene
    }
    
}
