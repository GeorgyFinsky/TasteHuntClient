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
    let c1 = CafeInAppModel(
        id: UUID(),
        name: "шаурма",
        phone: "1234555",
        profileImageURL: "/Users/georgyfinsky/Library/CloudStorage/OneDrive-Личная/Dev/GitHub/TasteHuntAPI//Storage/Cafes/B3C787AB-02A0-4A4F-8F8D-DD02316113C0.jpg",
        coordinates: CLLocation(latitude: 53.9, longitude: 27.5667),
        kitchens: ["asian", "belarusian"],
        mondayWorkTime: "12.00-23.00",
        thesdayWorkTime: "12.00-23.00",
        wednesdayWorkTime: "12.00-23.00",
        thusdayWorkTime: "12.00-23.00",
        fridayWorkTime: "12.00-23.00",
        saturdayWorkTime: "12.00-23.00",
        sundayWorkTime: "12.00-23.00")
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
        table.alpha = 0
        table.backgroundColor = .clear
        table.separatorColor = .purple
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    // MARK: -
    // MARK: Propertes
    private let locationManager = CLLocationManager()
    private var clusterManager: GMUClusterManager!
    private var cafes = [CafeInAppModel]() {
        didSet {
            clusterManager.clearItems()
            getNearestCafe()
            cafes.forEach({ self.clusterManager.add(CafeMarker(cafe: $0)) })
            clusterManager.cluster()
            tableView.reloadData()
        }
    }
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        setupLayout()
        makeConstraints()
        registerCell()
        getData()
        setupCluster()
        
        cafes = [c1, c1, c1]
    }
    
    private func registerCell() {
        tableView.register(
            UserTableCell.self,
            forCellReuseIdentifier: UserTableCell.id
        )
    }
    
    private func getData() {
        TasteHuntProvider().getAllCafes { [weak self] result in
            guard let self else { return }
            self.cafes = self.decodeToCafeInAppModel(cafeModels: result)
        } failure: { errorStrint in
            print(errorStrint)
        }
    }
    
    private func decodeToCafeInAppModel(cafeModels: [CafeModel]) -> [CafeInAppModel] {
        var outputArray = [CafeInAppModel]()
        
        cafeModels.forEach { cafe in
            let decodeCafe = CafeInAppModel(
                id: cafe.id,
                name: cafe.name,
                phone: cafe.phone,
                profileImageURL: cafe.profileImageURL,
                coordinates: CLLocation(
                    latitude: Double(cafe.gpsX) ?? 0.0,
                    longitude: Double(cafe.gpsY) ?? 0.0),
                kitchens: parseStringIntoArray(value: cafe.kitchens),
                mondayWorkTime: cafe.mondayWorkTime,
                thesdayWorkTime: cafe.thesdayWorkTime,
                wednesdayWorkTime: cafe.wednesdayWorkTime,
                thusdayWorkTime: cafe.thusdayWorkTime,
                fridayWorkTime: cafe.fridayWorkTime,
                saturdayWorkTime: cafe.saturdayWorkTime,
                sundayWorkTime: cafe.sundayWorkTime
            )
            outputArray.append(decodeCafe)
        }
        return outputArray
    }
    
    private func parseStringIntoArray(value: String) -> [String] {
        var outputArray = [String]()
        for i in value {
            var outputArrayObject: String = ""
            if i == "|" {
                outputArray.append(outputArrayObject)
                outputArrayObject = ""
            } else {
                outputArrayObject += String(i)
            }
        }
        return outputArray
    }
    
    private func setupCluster() {
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: self.mapView, clusterIconGenerator: iconGenerator)
        
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        clusterManager.setMapDelegate(self)
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
    
    private func getNearestCafe() {
        guard let userLocation = locationManager.location else { return }
        var nearestCafeDistanse: (CafeInAppModel, Double)?
        
        cafes.forEach { cafe in
            let distance = userLocation.distance(from: cafe.coordinates)
            
            if distance < nearestCafeDistanse?.1 ?? 1000000 {
                nearestCafeDistanse = (cafe, distance)
            }
        }
        
        setupMapCamera(
            lat: nearestCafeDistanse?.0.coordinates.coordinate.latitude ?? 27.0,
            lon: nearestCafeDistanse?.0.coordinates.coordinate.longitude ?? 57.0,
            zoom: 10
        )
    }
    
    private func setupMapCamera(lat: Double, lon: Double, zoom: Float) {
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: zoom)
        
        mapView.animate(to: camera)
    }
    
}

//MARK: -
//MARK: CafeMarker
final class CafeMarker: GMSMarker {
    var cafe: CafeInAppModel?
    
    convenience init(cafe: CafeInAppModel) {
        self.init(position: CLLocationCoordinate2D(
            latitude: cafe.coordinates.coordinate.latitude,
            longitude: cafe.coordinates.coordinate.longitude)
        )
        self.cafe = cafe
        self.icon = GMSMarker.markerImage(with: .purple)
    }
    
}

//MARK: -
//MARK: GMSMapViewDelegate
extension CafeController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        
        if marker.userData is GMUCluster {
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            return true
        }
        return false
    }
    
}

//MARK: -
//MARK: GMUClusterRendererDelegate
extension CafeController: GMUClusterRendererDelegate {
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if let cafeMarker = marker.userData as? CafeMarker {
            marker.icon = cafeMarker.icon
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
        cafes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableCell.id,
            for: indexPath
        ) as! UserTableCell
        cell.set(cafe: cafes[indexPath.row])
        
        return cell
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

// MARK: -
// MARK: CafeInAppModel
struct CafeInAppModel {
    var id: UUID
    var name: String
    var phone: String
    var profileImageURL: String
    var coordinates: CLLocation
    var kitchens: [String]
    var mondayWorkTime: String
    var thesdayWorkTime: String
    var wednesdayWorkTime: String
    var thusdayWorkTime: String
    var fridayWorkTime: String
    var saturdayWorkTime: String
    var sundayWorkTime: String
}
