//
//  SelectTableCell.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 22.03.23.
//

import UIKit
import SnapKit

final class SelectTableCell: UITableViewCell {
    static let id = String(describing: SelectTableCell.self)

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .purple
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        self.titleLabel.text = title
    }
    
    private func setupLayout() {
        self.contentView.addSubview(titleLabel)
    }
    
    private func makeConstraints() {
        let titleLabelEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(titleLabelEdges)
        }
    }
    
}
