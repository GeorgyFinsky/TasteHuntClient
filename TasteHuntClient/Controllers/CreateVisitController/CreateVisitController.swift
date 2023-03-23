//
//  CreateVisitController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import UIKit
import SnapKit

final class CreateVisitController: BaseController {
    
    // MARK: -
    // MARK: UIObjects
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var scrollViewContentView: UIView = {
        let view = UIView()
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
    
    private lazy var notificationView: UIView = {
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
    
    private lazy var notificationLabel: UILabel = {
        let label = createTitleLabel()
        label.text = "Reminder time:"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.alpha = 0
        table.backgroundColor = .clear
        table.separatorColor = .purple
        table.dataSource = self
        table.delegate = self
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
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
        picker.preferredDatePickerStyle = .wheels
        picker.date = Date()
        picker.timeZone = .current
        picker.datePickerMode = .dateAndTime
        return picker
    }()
    
    private lazy var selectNotificationTimeButton: UIButton = {
        let selectionClosure = {(action: UIAction) in
            switch action.title {
                case NotificationTimeType.never.rawValue:
                    self.selectedNotifyTime = NotificationTimeType.never
                case NotificationTimeType.oneDay.rawValue:
                    self.selectedNotifyTime = NotificationTimeType.oneDay
                case NotificationTimeType.oneHour.rawValue:
                    self.selectedNotifyTime = NotificationTimeType.oneHour
                case NotificationTimeType.oneMinute.rawValue:
                    self.selectedNotifyTime = NotificationTimeType.oneMinute
                default: break
            }
        }
        
        let button = UIButton()
        button.menu = UIMenu(children: [
            UIAction(title: NotificationTimeType.never.rawValue, state: .on, handler: selectionClosure),
            UIAction(title: NotificationTimeType.oneDay.rawValue, handler: selectionClosure),
            UIAction(title: NotificationTimeType.oneHour.rawValue, handler: selectionClosure),
            UIAction(title: NotificationTimeType.oneMinute.rawValue, handler: selectionClosure)
        ])
        button.showsMenuAsPrimaryAction = true
        button.changesSelectionAsPrimaryAction = true
        return button
    }()
    
    private lazy var createVisitButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
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
    
    // MARK: -
    // MARK: Propertes
    private(set) var type = CreateCafeControllerType.empty
    private var visit: VisitModel?
    private var cafeNAMEandID: (String, String)? {
        didSet {
            self.createVisitButton.isEnabled = true
        }
    }
    private var selectedNotifyTime: NotificationTimeType?
    private var allCafes = [CafeModel]()
    private var allGuests = [GuestModel]()
    private var visitGuests = [GuestModel]() {
        didSet {
            tableView.reloadData()
            tableView.snp.updateConstraints { make in
                make.height.equalTo(tableView.contentSize.height)
            }
            self.view.layoutIfNeeded()
        }
    }
    var updateBlock: (() -> ())?
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        makeConstraints()
        registerCell()
        getData()
    }
    
    func set(cafe: (String, String)) {
        self.type = .withSelectedCafe
        self.cafeNAMEandID = cafe
    }
    
    func set(visit: VisitModel) {
        self.type = .createdVisit
        self.visit = visit
    }
    
    private func setupData() {
        if type == .createdVisit {
            guard let visit else { return }
            
            let date = Date(timeIntervalSince1970: Double(visit.date) ?? 0.0)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM d, h:mm a"
            
            self.dateLabel.text = "Date: \(dayTimePeriodFormatter.string(from: date))"
            
            getVisitCafe(cafeID: visit.cafeID)
            getVisitGuests()
        }
        
        if type == .withSelectedCafe {
            guard let cafeNAMEandID else { return }
            
            getVisitCafe(cafeID: cafeNAMEandID.1)
        }
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
            self.allCafes = result
            self.setupData()
        } failure: { errorString in
            print(errorString)
        }
        
        TasteHuntProvider().getAllUsers { [weak self] result in
            guard let self,
                  let token = UserDefaults.standard.object(forKey: "accessToken") as? String,
                  let index = result.firstIndex(where: { $0.id.uuidString == token })
            else { return }
            
            self.allGuests = result
            self.allGuests.remove(at: index)
            self.setupData()
        } failure: { errorString in
            print(errorString)
        }
        
    }
    
    private func getVisitGuests() {
        guard let visit else { return }
        let visitGuestsIDs = parseStringIntoArray(value: visit.guestsID)
        var visitGiests = [GuestModel]()
        
        visitGuestsIDs.forEach { id in
            if let index = allGuests.firstIndex(where: { $0.id.uuidString == id }) {
                visitGiests.append(allGuests[index])
            }
        }
    }
    
    private func getVisitCafe(cafeID: String) {
        allCafes.forEach { cafe in
            if cafe.id.uuidString == cafeID {
                cafeLabel.text = "Cafe: \(cafe.name)"
                self.cafeNAMEandID = (cafe.name, cafe.id.uuidString)
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

// MARK: -
// MARK: SetupUI
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
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }
    
    private func setupLayout() {
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(scrollViewContentView)
        self.scrollViewContentView.addSubview(backButton)
        self.scrollViewContentView.addSubview(cafeView)
        self.scrollViewContentView.addSubview(guestsView)
        self.scrollViewContentView.addSubview(dateView)
        self.scrollViewContentView.addSubview(createVisitButton)
        self.cafeView.addSubview(cafeLabel)
        self.guestsView.addSubview(guestsLabel)
        self.guestsView.addSubview(tableView)
        self.dateView.addSubview(dateLabel)
        
        if type == .withSelectedCafe {
            self.scrollViewContentView.addSubview(notificationView)
            self.notificationView.addSubview(notificationLabel)
            self.notificationView.addSubview(selectNotificationTimeButton)
            self.guestsView.addSubview(addGuestButton)
            self.dateView.addSubview(datePicker)
            
        }
        
        if type == .empty {
            self.scrollViewContentView.addSubview(notificationView)
            self.notificationView.addSubview(notificationLabel)
            self.notificationView.addSubview(selectNotificationTimeButton)
            self.cafeView.addSubview(selectCafeButton)
            self.guestsView.addSubview(addGuestButton)
            self.dateView.addSubview(datePicker)
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
        
        let viewEdges = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cafeView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(viewEdges.top)
            make.leading.trailing.equalToSuperview().inset(viewEdges)
        }
        
        let contentEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(guestsLabel.snp.bottom).offset(contentEdges.top)
            make.leading.trailing.equalToSuperview().inset(contentEdges)
            make.height.equalTo(tableView.contentSize.height)
        }
        
        guestsView.snp.makeConstraints { make in
            make.top.equalTo(cafeView.snp.bottom).offset(viewEdges.top)
            make.leading.trailing.equalToSuperview().inset(viewEdges)
            make.bottom.equalTo(tableView.snp.bottom)
        }
        
        let titleLabelEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cafeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(titleLabelEdges)
        }
        
        guestsLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(titleLabelEdges)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(titleLabelEdges)
        }
        
        let buttonsEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if type == .createdVisit {
            dateView.snp.makeConstraints { make in
                make.top.equalTo(guestsView.snp.bottom).offset(viewEdges.top)
                make.bottom.equalTo(dateLabel.snp.bottom).offset(10)
                make.leading.trailing.bottom.equalToSuperview().inset(viewEdges)
            }
        }
        
        if type == .withSelectedCafe {
            dateView.snp.makeConstraints { make in
                make.top.equalTo(guestsView.snp.bottom).offset(viewEdges.top)
                make.leading.trailing.equalToSuperview().inset(viewEdges)
            }
            
            notificationView.snp.makeConstraints { make in
                make.top.equalTo(dateView.snp.bottom).offset(viewEdges.top)
                make.leading.trailing.equalToSuperview().inset(viewEdges)
            }
            
            notificationLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(titleLabelEdges)
                make.bottom.equalToSuperview().inset(titleLabelEdges)
            }
            
            selectNotificationTimeButton.snp.makeConstraints { make in
                make.leading.equalTo(notificationLabel.snp.trailing).offset(buttonsEdges.left)
                make.centerY.equalTo(notificationLabel.snp.centerY)
                make.height.equalTo(35)
            }
            
            addGuestButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(buttonsEdges)
                make.centerY.equalTo(guestsLabel.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(150)
            }
            
            datePicker.snp.makeConstraints { make in
                make.top.equalTo(dateLabel.snp.bottom).offset(10)
                make.leading.trailing.bottom.equalToSuperview().inset(10)
            }
            
            createVisitButton.snp.makeConstraints { make in
                make.top.equalTo(notificationView.snp.bottom).offset(viewEdges.top)
                make.leading.trailing.bottom.equalToSuperview().inset(viewEdges)
                make.height.equalTo(40)
            }
            
        }
        
        if type == .empty {
            selectCafeButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(buttonsEdges)
                make.centerY.equalTo(cafeLabel.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(150)
            }
            
            dateView.snp.makeConstraints { make in
                make.top.equalTo(guestsView.snp.bottom).offset(viewEdges.top)
                make.leading.trailing.equalToSuperview().inset(viewEdges)
            }

            notificationView.snp.makeConstraints { make in
                make.top.equalTo(dateView.snp.bottom).offset(viewEdges.top)
                make.leading.trailing.equalToSuperview().inset(viewEdges)
            }
            
            notificationLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().inset(titleLabelEdges)
                make.bottom.equalToSuperview().inset(titleLabelEdges)
            }
            
            selectNotificationTimeButton.snp.makeConstraints { make in
                make.leading.equalTo(notificationLabel.snp.trailing).offset(buttonsEdges.left)
                make.centerY.equalTo(notificationLabel.snp.centerY)
                make.height.equalTo(35)
            }
            
            addGuestButton.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(buttonsEdges)
                make.centerY.equalTo(guestsLabel.snp.centerY)
                make.height.equalTo(35)
                make.width.equalTo(150)
            }
            
            datePicker.snp.makeConstraints { make in
                make.top.equalTo(dateLabel.snp.bottom).offset(10)
                make.leading.trailing.bottom.equalToSuperview().inset(10)
            }
            
            createVisitButton.snp.makeConstraints { make in
                make.top.equalTo(notificationView.snp.bottom).offset(viewEdges.top)
                make.leading.trailing.bottom.equalToSuperview().inset(viewEdges)
                make.height.equalTo(40)
            }
        }
    }
    
}

// MARK: -
// MARK: Buttons Action
extension CreateVisitController {
    
    @objc private func selectionButtonDidTap(sender: UIButton) {
        let searchVC = SearchTableController()
        var value = [(String, String)]()
        
        if sender == selectCafeButton {
            allCafes.forEach { cafe in
                value.append((cafe.name, cafe.id.uuidString))
            }
            searchVC.selectBlock = { cafeID in
                self.getVisitCafe(cafeID: cafeID)
            }
        }
        if sender == addGuestButton {
            allGuests.forEach { user in
                value.append((user.username, user.id.uuidString))
            }
            searchVC.selectBlock = { guestID in
                if let index = self.allGuests.firstIndex(where: { $0.id.uuidString == guestID }) {
                    self.visitGuests.append(self.allGuests[index])
                }
            }
        }
        
        searchVC.set(value: value)
        
        self.present(searchVC, animated: true)
    }
    
    @objc private func saveButtonDidTap() {
        guard let cafeNAMEandID,
              let token = UserDefaults.standard.object(forKey: "accessToken") as? String else { return }
        
        var visitGuestsID = [String]()
        
        visitGuestsID.append(token)
        visitGuests.forEach { guest in
            visitGuestsID.append(guest.id.uuidString)
        }
        
        TasteHuntProvider().createVisit(
            id: UUID(),
            guestsID: parseArrayIntoString(value: visitGuestsID),
            cafeID: cafeNAMEandID.1,
            date: String(datePicker.date.timeIntervalSince1970)
        ) { [weak self] result in
            guard let self else { return }
            self.popToRoot(animated: true)
            self.updateBlock?()
        } failure: { errorString in
            print(errorString)
        }
    }
    
    @objc func backButtonDidTap(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
}

// MARK: -
// MARK: UITableViewDelegate
extension CreateVisitController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: -
// MARK: UITableViewDataSource
extension CreateVisitController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitGuests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableCell.id,
            for: indexPath
        ) as! UserTableCell
        cell.set(guest: visitGuests[indexPath.row])
        
        return cell
    }
    
}
