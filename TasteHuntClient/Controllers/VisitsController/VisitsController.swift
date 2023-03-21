//
//  VisitsController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import UIKit
import SnapKit

final class VisitsController: BaseController {
    
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
        label.text = "Visits"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorColor = .purple
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var isEmptyView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var isEmptyViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "You have no scheduled visits"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var createVisitButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(createVisitButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var reloadDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(
            UIImage(systemName: "goforward"),
            for: .normal
        )
        button.addTarget(
            self,
            action: #selector(reloadData),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: -
    // MARK: Propertes
    private var visits = [VisitModel]()
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupLayout()
        makeConstraints()
        getData()
        collapse()
    }
    
    private func registerCell() {
        tableView.register(
            UserTableCell.self,
            forCellReuseIdentifier: UserTableCell.id
        )
    }
    
    private func getData() {
        TasteHuntProvider().getUserVisits { [weak self] result in
            guard let self else { return }
            result.forEach { visit in
                let visitDate = Date(timeIntervalSince1970: Double(visit.date) ?? 0.0)
                if visitDate < Date() {
                    self.visits.append(visit)
                }
            }
            self.collapse()
        } failure: { errorString in
            print(errorString)
        }
    }
    
}

// MARK: -
// MARK: SetupUI
extension VisitsController {
    
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(topContainerView)
        self.topContainerView.addSubview(stack)
        self.topContainerView.addSubview(titleLabel)
        self.stack.addArrangedSubview(reloadDataButton)
        self.stack.addArrangedSubview(createVisitButton)
        self.contentView.addSubview(tableView)
        self.contentView.addSubview(isEmptyView)
        self.isEmptyView.addSubview(isEmptyViewTitleLabel)
    }
    
    private func makeConstraints() {
        topContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
        }
        
        reloadDataButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        createVisitButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        isEmptyView.snp.makeConstraints { make in
            make.top.equalTo(isEmptyViewTitleLabel.snp.top).offset(-20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(isEmptyViewTitleLabel.snp.bottom).offset(20)
            make.centerY.centerX.equalToSuperview()
        }
        
        isEmptyViewTitleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func collapse() {
        if self.visits.count == 0 {
            isEmptyView.alpha = 1
            tableView.alpha = 0
        } else {
            isEmptyView.alpha = 0
            tableView.alpha = 1
        }
    }
    
}

// MARK: -
// MARK: Buttons Action
extension VisitsController {
    
    @objc private func createVisitButtonDidTap() {
        let createVisetVC = CreateVisitController()
        
        self.push(createVisetVC, animated: true)
    }
    
    @objc private func reloadData() {
        self.visits.removeAll()
        self.getData()
    }
    
}

// MARK: -
// MARK: Buttons Action
extension VisitsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let visitVC = VisitController()
        visitVC.set(visit: visits[indexPath.row])
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.push(visitVC, animated: true)
    }
    
}

// MARK: -
// MARK: Buttons Action
extension VisitsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableCell.id,
            for: indexPath
        ) as! UserTableCell
        cell.set(visit: visits[indexPath.row])
        
        return cell
    }
    
}
