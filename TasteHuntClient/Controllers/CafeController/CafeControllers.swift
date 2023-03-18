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
        label.text = "Cafes"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var segmentControll: UniversalSegmenControl = {
        let segment = UniversalSegmenControl(
            elements: CafeControllerDisplayType.allCases,
            delegate: self
        )
        return segment
    }()
    
    private lazy var mapView: GMSMapView = {
        let map = GMSMapView()
        return map
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorColor = .purple
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        makeConstraints()
        registerCell()
    }
    
    private func registerCell() {
        
    }
    
}

// MARK: -
// MARK: SetupUI
extension CafeController {
    
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(mapView)
        self.view.addSubview(tableView)
        self.view.addSubview(topContainerView)
        self.topContainerView.addSubview(titleLabel)
        self.topContainerView.addSubview(segmentControll)
        
    }
    
    private func makeConstraints() {
        let segmentControllEdges = UIEdgeInsets(top: 16, left: 20, bottom: 20, right: 20)
        
        topContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(segmentControll.snp.bottom).offset(segmentControllEdges.bottom)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(topContainerView.snp.bottom).inset(25)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topContainerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(10)
            make.centerX.equalToSuperview()
        }
        
        segmentControll.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(segmentControllEdges.top)
            make.leading.trailing.equalToSuperview().inset(segmentControllEdges)
        }
    }
    
}

// MARK: -
// MARK: UITableViewDelegate
extension CafeController: UITableViewDelegate {
    
}

// MARK: -
// MARK: UITableViewDataSource
extension CafeController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}

// MARK: -
// MARK: SegmentDelegate
extension CafeController: SegmentDelegate {
    
    func segmentDidChange(index: Int) {
        if index == 0 {
            mapView.alpha = 1
            tableView.alpha = 0
        } else {
            mapView.alpha = 0
            tableView.alpha = 1
        }
    }
    
}
