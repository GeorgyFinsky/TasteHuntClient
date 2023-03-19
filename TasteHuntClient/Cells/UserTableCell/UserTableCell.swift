//
//  UserTableCell.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 18.03.23.
//

import UIKit
import SnapKit
import SDWebImage

final class UserTableCell: UITableViewCell {
    static let id = String(describing: UserTableCell.self)
    
    private lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.tintColor = .purple
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 26)
        label.textColor = .purple
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var kitchensLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    private(set) var type = UserTableCellType.cafe
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cafe: CafeInAppModel) {
        var kitchens: String = ""
        
        self.type = .cafe
        self.nameLabel.text = cafe.name
        self.profileImage.sd_setImage(with: URL(string: cafe.profileImageURL))
        self.profileImage.image = UIImage(systemName: "person")!.withTintColor(.purple)
        
        cafe.kitchens.forEach { kitchen in
            kitchens += "\(kitchen) "
        }
        
        self.kitchensLabel.text = kitchens
    }
    
    func set(guest: GuestModel) {
        self.type = .guest
        self.nameLabel.text = guest.username
        if guest.profileImageURL != "" {
            self.profileImage.sd_setImage(with: URL(string: guest.profileImageURL))
        } else {
            self.profileImage.image = UIImage(systemName: "person")
        }
    }
    
    func setupLayout() {
        self.contentView.addSubview(profileImage)
        self.contentView.addSubview(nameLabel)
        if type == .cafe {
            self.contentView.addSubview(kitchensLabel)
        }
    }
    
    func makeConstraints() {
        let profileImageEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        profileImage.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.top.leading.bottom.equalToSuperview().inset(profileImageEdges)
        }
        
        if self.type == .cafe {
            nameLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(14)
                make.leading.equalTo(profileImage.snp.trailing).offset(14)
                make.trailing.equalToSuperview()
            }
            
            kitchensLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.leading.equalTo(profileImage.snp.trailing).offset(14)
                make.trailing.bottom.equalToSuperview().inset(10)
            }
        } else {
            nameLabel.snp.makeConstraints { make in
                make.leading.equalTo(profileImage.snp.trailing).offset(14)
                make.trailing.equalToSuperview()
                make.centerX.equalToSuperview()
            }
        }
    }
    
}
