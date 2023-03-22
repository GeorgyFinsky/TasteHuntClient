//
//  CafeProfileController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import UIKit
import SnapKit
import GoogleMaps
import SDWebImage

final class CafeProfileController: BaseController {
    
    // MARK: -
    // MARK: UIObjects
    private lazy var profileImageView: UIImageView = {
       let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .purple
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 40)
        return label
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var workTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var createVisitButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .purple
        button.layer.cornerRadius = 8
        button.setTitle("Create Visit", for: .normal)
        button.addTarget(
            self,
            action: #selector(createVisitButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var viewMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .purple
        button.layer.cornerRadius = 8
        button.setTitle("Menu", for: .normal)
        button.addTarget(
            self,
            action: #selector(menuButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var mapView: GMSMapView = {
        let map = GMSMapView()
        map.layer.cornerRadius = 8
        return map
    }()
    
    // MARK: -
    // MARK: Propertes
    private(set) var cafe: CafeInAppModel?
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cafe else { return }
        setupLayout()
        makeConstraints()
        setupData()
        setupMapCamera(
            lat: cafe.coordinates.coordinate.latitude,
            lon: cafe.coordinates.coordinate.longitude,
            zoom: 8
        )
    }
    
    func set(cafe: CafeInAppModel) {
        self.cafe = cafe
    }
    
    private func setupData() {
        guard let cafe else { return }
        self.nameLabel.text = cafe.name
        self.phoneLabel.text = cafe.phone
        self.workTimeLabel.text = "Monday: \(cafe.mondayWorkTime)\nThesday: \(cafe.thesdayWorkTime)\nWednesday: \(cafe.wednesdayWorkTime)\nThusday: \(cafe.thusdayWorkTime)\nFriday: \(cafe.fridayWorkTime)\nSaturday \(cafe.saturdayWorkTime)\nSunday: \(cafe.sundayWorkTime)"
    }
    
}

// MARK: -
// MARK: SetupUI
extension CafeProfileController {
    
    private func setupLayout() {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(phoneLabel)
        self.contentView.addSubview(stack)
        self.stack.addArrangedSubview(createVisitButton)
        self.stack.addArrangedSubview(viewMenuButton)
        self.contentView.addSubview(mapView)
        self.contentView.addSubview(workTimeLabel)
    }
    
    private func makeConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        
        phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        createVisitButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        viewMenuButton.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).offset(20)
            make.height.equalTo(200)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        workTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupMapCamera(lat: Double, lon: Double, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: zoom)
        
        mapView.animate(to: camera)
    }
    
}

// MARK: -
// MARK: Buttons Action
extension CafeProfileController {
    
    @objc private func createVisitButtonDidTap() {
        guard let cafe else { return }
        let createVisitVC = CreateVisitController()
        createVisitVC.set(cafe: (cafe.name, cafe.id.uuidString))
        
        self.push(createVisitVC, animated: true)
    }
    
    @objc private func menuButtonDidTap() {
        
    }
    
}
