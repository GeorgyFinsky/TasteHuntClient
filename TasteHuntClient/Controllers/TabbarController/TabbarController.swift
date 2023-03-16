//
//  TabbarController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import UIKit

final class BaseTabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateTabBar()
        self.tabBar.backgroundColor = .darkGray.withAlphaComponent(0.6)
        self.tabBar.tintColor = .purple
        self.tabBar.layer.opacity = 0.6
    }
    
    private func configurateTabBar() {
        let visitsVC = VisitsController()
        let cafesVC = CafesController()
        let settingsVC = SettingsController()
        
        self.viewControllers = [visitsVC, cafesVC, settingsVC]
        visitsVC.tabBarItem = UITabBarItem(
            title: "Visits",
            image: UIImage(systemName: "map"),
            tag: 0
        )
        cafesVC.tabBarItem = UITabBarItem(
            title: "Cafes",
            image: UIImage(systemName: "cup.and.saucer"),
            tag: 1
        )
        settingsVC.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 2
        )
    }
    
}
