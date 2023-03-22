//
//  SearchTableViewController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 22.03.23.
//

import UIKit
import SnapKit

final class SearchTableController: UIViewController {
    
    // MARK: -
    // MARK: UIObjects
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.separatorColor = .purple
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    // MARK: -
    // MARK: Propertes
    private var value = [(String, String)]()
    private var filteredValue = [(String, String)]()
    var selectBlock: ((String) -> ())?
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.filteredValue = value
        registerCell()
        setupLayout()
        makeConstraint()
    }
    
    func set(value: [(String, String)]) {
        self.value = value
    }
    
    private func registerCell() {
        tableView.register(
            SelectTableCell.self,
            forCellReuseIdentifier: SelectTableCell.id
        )
    }
    
}

// MARK: -
// MARK: SetupUI
extension SearchTableController {
    
    private func setupLayout() {
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
    }
    
    private func makeConstraint() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

// MARK: -
// MARK: UITableViewDelegate
extension SearchTableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
        selectBlock?(filteredValue[indexPath.row].1)
    }
    
}

// MARK: -
// MARK: UITableViewDataSource
extension SearchTableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectTableCell.id,
            for: indexPath
        ) as! SelectTableCell
        cell.set(title: filteredValue[indexPath.row].0)
        
        return cell
    }
    
}

// MARK: -
// MARK: UISearchBarDelegate
extension SearchTableController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredValue = searchText.isEmpty ? value : value.filter { (item: (String,String)) -> Bool in
            return item.0.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
}
