//
//  SelectKitchenCoollectionViewCell.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 12.03.23.
//

import UIKit
import SnapKit

final class SelectKitchenCoollectionViewCell: UICollectionViewCell {
    static let id = String(describing: SelectKitchenCoollectionViewCell.self)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
        setupLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContentView() {
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.purple.cgColor
        self.contentView.layer.cornerRadius = 5
    }
    
    func set(value: KitchenSelectModel) {
        
    }
    
    private func setupLayout() {
        self.contentView.addSubview(imageView)
    }
    
    private func makeConstraints() {
        let imageViewEdges = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(imageViewEdges)
        }
    }
    
}
