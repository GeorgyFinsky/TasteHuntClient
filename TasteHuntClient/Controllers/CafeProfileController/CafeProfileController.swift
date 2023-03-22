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
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var scrollViewContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(
            UIImage(systemName: "chevron.backward"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(backButtonDidTap(sender:)),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 100
        imageView.tintColor = .purple
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
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var daysTitleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var workTimeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
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
        map.layer.cornerRadius = 10
        return map
    }()
    
    // MARK: -
    // MARK: Propertes
    private(set) var cafe: CafeInAppModel?
    private let workDays = WorkTimeLabelType.allCases
    private var workDaysLabels = [UILabel]()
    private var workTimeLabels = [UILabel]()
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cafe else { return }
        setupLayout()
        makeConstraints()
        setupData()
        createMarker(coordinates: cafe.coordinates)
    }
    
    func set(cafe: CafeInAppModel) {
        self.cafe = cafe
    }
    
    private func setupData() {
        guard let cafe else { return }
        self.profileImageView.sd_setImage(with: URL(string: cafe.profileImageURL))
        self.nameLabel.text = cafe.name
        self.phoneLabel.text = cafe.phone
    }
    
}

// MARK: -
// MARK: SetupUI
extension CafeProfileController {
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        return label
    }
    
    private func setupLayout() {
        self.contentView.addSubview(scrollView)
        self.scrollView.addSubview(scrollViewContentView)
        self.scrollViewContentView.addSubview(profileImageView)
        self.scrollViewContentView.addSubview(backButton)
        self.scrollViewContentView.addSubview(nameLabel)
        self.scrollViewContentView.addSubview(phoneLabel)
        self.scrollViewContentView.addSubview(buttonsStack)
        self.scrollViewContentView.addSubview(mapView)
        self.scrollViewContentView.addSubview(stack)
        self.buttonsStack.addArrangedSubview(createVisitButton)
        self.buttonsStack.addArrangedSubview(viewMenuButton)
        self.stack.addArrangedSubview(daysTitleStack)
        self.stack.addArrangedSubview(workTimeStack)
        
        workDays.forEach { day in
            let label = createLabel()
            let workTimeLabel = createLabel()
            let index = workDaysLabels.count
            
            label.text = day.rawValue
            self.daysTitleStack.addArrangedSubview(label)
            self.workDaysLabels.append(label)
            
            switch index {
                case 0:
                    workTimeLabel.text = self.cafe?.mondayWorkTime
                case 1:
                    workTimeLabel.text = self.cafe?.thesdayWorkTime
                case 2:
                    workTimeLabel.text = self.cafe?.wednesdayWorkTime
                case 3:
                    workTimeLabel.text = self.cafe?.thusdayWorkTime
                case 4:
                    workTimeLabel.text = self.cafe?.fridayWorkTime
                case 5:
                    workTimeLabel.text = self.cafe?.saturdayWorkTime
                case 6:
                    workTimeLabel.text = self.cafe?.sundayWorkTime
                default: break
            }
            
            self.workTimeStack.addArrangedSubview(workTimeLabel)
            self.workTimeLabels.append(workTimeLabel)
        }
    }
    
    private func makeConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(self.view)
        }
        
        scrollViewContentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(self.view)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().inset(16)
            make.height.width.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
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
        
        buttonsStack.snp.makeConstraints { make in
            make.top.equalTo(phoneLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(buttonsStack.snp.bottom).offset(20)
            make.height.equalTo(300)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.leading.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
    }
    
    private func createMarker(coordinates: CLLocation) {
        let marker = GMSMarker(position: CLLocationCoordinate2D(
            latitude: coordinates.coordinate.latitude,
            longitude: coordinates.coordinate.longitude
        ))
        marker.icon = GMSMarker.markerImage(with: UIColor.purple)
        marker.map = mapView
        
        mapView.animate(toLocation: marker.position)
        mapView.animate(toZoom: 15)
    }
    
}

// MARK: -
// MARK: Buttons Action
extension CafeProfileController {
    
    @objc func backButtonDidTap(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @objc private func createVisitButtonDidTap() {
        guard let cafe else { return }
        let createVisitVC = CreateVisitController()
        createVisitVC.set(cafe: (cafe.name, cafe.id.uuidString))
        
        self.push(createVisitVC, animated: true)
    }
    
    @objc private func menuButtonDidTap() {
        
    }
    
}
