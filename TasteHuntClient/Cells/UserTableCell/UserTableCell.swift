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
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
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
    
    private lazy var infoLabel: UILabel = {
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
        
        cafe.kitchens.forEach { kitchen in
            kitchens += "\(kitchen) "
        }
        
        self.infoLabel.text = kitchens
    }
    
    func set(visit: VisitModel) {
        self.type = .visit
        
        getData(cafeID: visit.cafeID)
        
        let date = Date(timeIntervalSince1970: Double(visit.date) ?? 0.0)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM d, h:mm a"
        self.infoLabel.text = dayTimePeriodFormatter.string(from: date)
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
    
    private func setupLayout() {
        self.contentView.addSubview(nameLabel)
        if type == .cafe {
            self.contentView.addSubview(profileImage)
            self.contentView.addSubview(infoLabel)
        } else if type == .guest {
            self.contentView.addSubview(profileImage)
        } else if type == .visit {
            self.contentView.addSubview(infoLabel)
        }
    }
    
    private func makeConstraints() {
        if type == .cafe {
            let profileImageEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            profileImage.snp.makeConstraints { make in
                make.height.width.equalTo(70)
                make.top.leading.bottom.equalToSuperview().inset(profileImageEdges)
            }
            
            nameLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(14)
                make.leading.equalTo(profileImage.snp.trailing).offset(14)
                make.trailing.equalToSuperview()
            }
            
            infoLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.leading.equalTo(profileImage.snp.trailing).offset(14)
                make.trailing.bottom.equalToSuperview().inset(10)
            }
        } else if type == .guest {
            let profileImageEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            profileImage.snp.makeConstraints { make in
                make.height.width.equalTo(70)
                make.top.leading.bottom.equalToSuperview().inset(profileImageEdges)
            }
            
            nameLabel.snp.makeConstraints { make in
                make.leading.equalTo(profileImage.snp.trailing).offset(14)
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        } else if type == .visit {
            let labelEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            nameLabel.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview().inset(labelEdges)
            }
            
            infoLabel.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).offset(4)
                make.leading.trailing.bottom.equalToSuperview().inset(labelEdges)
            }
        }
    }
    
    private func getData(cafeID: String) {
        TasteHuntProvider().getCafe(cafeID: cafeID) { [weak self] result in
            self?.nameLabel.text = result.name
        } failure: { errorString in
            print(errorString)
        }
    }
    
}
