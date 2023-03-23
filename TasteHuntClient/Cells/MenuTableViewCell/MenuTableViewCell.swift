//
//  MenuTableViewCell.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 23.03.23.
//

import UIKit
import SnapKit
import SDWebImage

final class MenuTableViewCell: UITableViewCell {
    static let id = String(describing: MenuTableViewCell.self)

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .purple
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 20)
        label.textColor = .purple
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.tintColor = .purple
        return imageView
    }()
            
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(dich: DichModel) {
        self.profileImage.sd_setImage(with: URL(string: dich.profileImageURL))
        self.nameLabel.text = dich.name
        self.priceLabel.text = dich.price
    }
    
    private func setupLayout() {
        self.backgroundColor = .systemGray6
        self.contentView.addSubview(profileImage)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(priceLabel)
    }
    
    private func makeConstraints() {
        let profileImageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(profileImageInsets)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImage.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
}
