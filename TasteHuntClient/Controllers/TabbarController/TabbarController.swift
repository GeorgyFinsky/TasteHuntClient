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
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.view.bounds
        
        self.tabBar.tintColor = .white
        self.tabBar.backgroundColor = .clear
        self.tabBar.addSubview(blurView)
        self.tabBar.sendSubviewToBack(blurView)
    }
    
    private func configurateTabBar() {
        let visitsVC = UINavigationController(rootViewController: VisitsController())
        let cafesVC = UINavigationController(rootViewController: CafeController())
        let settingsVC = UINavigationController(rootViewController: SettingsController())
        
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
