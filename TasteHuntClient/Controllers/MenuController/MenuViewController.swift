//
//  MenuViewController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 23.03.23.
//

import UIKit
import SnapKit

final class MenuViewController: BaseController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Menu"
        label.textColor = .purple
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var tableView: UITableView = {
       let table = UITableView()
        table.backgroundColor = .clear
        table.separatorColor = .purple
        table.dataSource = self
        return table
    }()
    
    private(set) var cafeID: String?
    private var cafeDiches: [DichModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupLayout()
        makeConstraint()
        getData()
    }
    
    func set(cafeID: String) {
        self.cafeID = cafeID
    }
    
    private func registerCell() {
        tableView.register(
            MenuTableViewCell.self,
            forCellReuseIdentifier: MenuTableViewCell.id
        )
    }
    
    private func getData() {
        guard let cafeID else { return }
        TasteHuntProvider().getCafeMenu(cafeID: cafeID) { [weak self] result in
            guard let self else { return }
            
            self.cafeDiches = result
        } failure: { errorString in
            print(errorString)
        }
    }
    
}

extension MenuViewController {
    
    private func setupLayout() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(tableView)
    }
    
    private func makeConstraint() {
        let titleLabelInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(titleLabelInsets)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cafeDiches else { return 0 }
        
        return cafeDiches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MenuTableViewCell.id,
            for: indexPath
        ) as! MenuTableViewCell
        
        guard let cafeDiches else { return cell }
        
        cell.set(dich: cafeDiches[indexPath.row])
        
        return cell
    }
    
}
