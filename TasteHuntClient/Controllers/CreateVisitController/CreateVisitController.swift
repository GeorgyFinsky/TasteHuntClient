//
//  CreateVisitController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import UIKit
import SnapKit

final class CreateVisitController: BaseController {
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var scrollViewContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var cafeView: UIView = {
        let view = createConteinerView()
        return view
    }()
    
    private lazy var guestsView: UIView = {
        let view = createConteinerView()
        return view
    }()
    
    private lazy var dateView: UIView = {
        let view = createConteinerView()
        return view
    }()
    
    private lazy var cafeLabel: UILabel = {
        let label = createTitleLabel()
        label.text = "Cafe:"
        return label
    }()
    
    private lazy var guestsLabel: UILabel = {
        let label = createTitleLabel()
        label.text = "Guests:"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = createTitleLabel()
        label.text = "Date:"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.alpha = 0
        table.backgroundColor = .clear
        table.separatorColor = .purple
        table.dataSource = self
        return table
    }()
    
    private lazy var selectCafeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .purple
        button.layer.cornerRadius = 8
        button.setTitle("Select Cafe", for: .normal)
        button.addTarget(
            self,
            action: #selector(selectionButtonDidTap(sender:)),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var addGuestButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .purple
        button.layer.cornerRadius = 8
        button.setTitle("Add guest", for: .normal)
        button.addTarget(
            self,
            action: #selector(selectionButtonDidTap(sender:)),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.timeZone = .current
        picker.datePickerMode = .dateAndTime
        return picker
    }()
    
    private lazy var createVisitButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .purple
        button.layer.cornerRadius = 8
        button.setTitle("Create Visit", for: .normal)
        button.addTarget(
            self,
            action: #selector(saveButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    private(set) var type = CreateCafeControllerType.empty
    private var visit: VisitModel?
    private var cafe: (String, String)?
    private var users = [GuestModel]()
    private var cafes = [CafeModel]()
    private var visitUsers = [GuestModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        registerCell()
        makeConstraints()
        getData()
    }
    
    func set(cafe: (String, String)) {
        self.type = .withSelectedCafe
        self.cafe = cafe
    }
    
    func set(visit: VisitModel) {
        self.type = .createdVisit
        self.visit = visit
        setupData()
    }
    
    private func setupData() {
        guard let visit else { return }
        let date = Date(timeIntervalSince1970: Double(visit.date) ?? 0.0)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM d, h:mm a"
        
        self.dateLabel.text = "Date: \(dayTimePeriodFormatter.string(from: date))"
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
            self.cafes = result
            self.type == .createdVisit ? self.getVisitCafe(cafeID: self.visit?.cafeID ?? "") : nil
        } failure: { errorString in
            print(errorString)
        }
        
        TasteHuntProvider().getAllUsers { [weak self] result in
            guard let self else { return }
            self.users = result
            self.type == .createdVisit ? self.getVisitGuests() : nil
        } failure: { errorString in
            print(errorString)
        }
        
    }
    
    private func getVisitGuests() {
        guard let visit else { return }
        var visitGuestsIDs = parseStringIntoArray(value: visit.guestsID)
        var visitGiests = [GuestModel]()
        
        visitGuestsIDs.forEach { id in
            if let index = users.firstIndex(where: { $0.id.uuidString == id }) {
                visitGiests.append(users[index])
            }
        }
    }
    
    private func getVisitCafe(cafeID: String) {
        cafes.forEach { cafe in
            if cafe.id.uuidString == cafeID {
                cafeLabel.text = "Cafe: \(cafe.name)"
                self.cafe = (cafe.name, cafe.id.uuidString)
            }
        }
    }
    
    private func parseStringIntoArray(value: String) -> [String] {
        var outputArray = [String]()
        var outputArrayObject: String = ""
        for i in value {
            if i == "|" {
                outputArray.append(outputArrayObject)
                outputArrayObject = ""
            } else {
                outputArrayObject += String(i)
            }
        }
        return outputArray
    }
    
    private func parseArrayIntoString(value: [String]) -> String {
        var outputValue: String = ""
        
        value.forEach { item in
            outputValue += "\(item)|"
        }
        return outputValue
    }
    
}

extension CreateVisitController {
    
    private func createConteinerView() -> UIView {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.cornerRadius = 10
        return view
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .purple
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }
    
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = false
        self.contentView.addSubview(scrollView)
        self.scrollView.addSubview(scrollViewContentView)
        self.scrollViewContentView.addSubview(cafeView)
        self.scrollViewContentView.addSubview(guestsView)
        self.scrollViewContentView.addSubview(dateView)
        self.cafeView.addSubview(cafeLabel)
        self.guestsView.addSubview(guestsLabel)
        self.dateLabel.addSubview(dateLabel)
        
        if type == .withSelectedCafe, type == .empty {
            self.guestsView.addSubview(addGuestButton)
            self.guestsView.addSubview(tableView)
            self.dateView.addSubview(datePicker)
        }
        
        if type == .empty {
            self.cafeView.addSubview(selectCafeButton)
        }
    }
    
    private func makeConstraints() {
        cafeView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(cafeLabel.snp.bottom).offset(16)
        }
        
        let cafeLabelEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cafeLabel.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(cafeLabelEdges)
        }
        
        selectCafeButton.snp.makeConstraints { make in
            make.centerY.equalTo(cafeLabel.snp.centerY)
            make.leading.equalTo(cafeLabel.snp.trailing).inset(20)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        guestsView.snp.makeConstraints { make in
            make.top.equalTo(cafeView.snp.bottom).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(tableView.snp.bottom).offset(16)
        }
        
        let guestLabelEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        guestsLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(guestLabelEdges)
        }
        
        addGuestButton.snp.makeConstraints { make in
            make.centerY.equalTo(guestsLabel.snp.centerY)
            make.leading.equalTo(guestsLabel.snp.trailing).inset(20)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(guestsLabel.snp.bottom).inset(20)
            make.height.equalTo(200)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(guestsView.snp.bottom).inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(16)
        }
        
        let dateLabelEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(dateLabelEdges)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).inset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

extension CreateVisitController {
    
    @objc private func selectionButtonDidTap(sender: UIButton) {
        let searchVC = SearchTableController()
        var value = [(String, String)]()
        
        if sender == selectCafeButton {
            cafes.forEach { cafe in
                value.append((cafe.name, cafe.id.uuidString))
            }
            searchVC.selectBlock = { cafeID in
                self.getVisitCafe(cafeID: cafeID)
            }
        }
        if sender == addGuestButton {
            users.forEach { user in
                value.append((user.username, user.id.uuidString))
            }
        }
        
        searchVC.set(value: value)
        
        self.present(searchVC, animated: true)
    }
    
    @objc private func saveButtonDidTap() {
        guard let cafe else { return }
        var guestsID = [String]()
        visitUsers.forEach { user in
            guestsID.append(user.id.uuidString)
        }
        
        TasteHuntProvider().createVisit(
            id: UUID(),
            guestsID: parseArrayIntoString(value: guestsID),
            cafeID: cafe.1,
            date: String(datePicker.date.timeIntervalSince1970)
        ) { [weak self] result in
            guard let self else { return }
            self.popToRoot(animated: true)
        } failure: { errorString in
            print(errorString)
        }
    }
    
}

extension CreateVisitController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableCell.id,
            for: indexPath
        ) as! UserTableCell
        cell.set(guest: visitUsers[indexPath.row])
        
        return cell
    }
    
}
