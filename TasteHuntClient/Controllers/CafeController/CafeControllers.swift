//
//  CafeControllers.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils
import CoreLocation
import SnapKit

final class CafeController: BaseController {
    
    // MARK: -
    // MARK: UIObjects
    private lazy var topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Authorization"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .large
        return activityView
    }()
    
    private lazy var reloadDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "goforward"),
            for: .normal
        )
        return button
    }()
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        makeConstraints()
    }
    
}

// MARK: -
// MARK: SetupUI
extension CafeController {
    
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(topContainerView)
        self.topContainerView.addSubview(titleLabel)
        self.topContainerView.addSubview(reloadDataButton)
        self.topContainerView.addSubview(activityIndicator)
    }
    
    private func makeConstraints() {
        
    }
    
}
