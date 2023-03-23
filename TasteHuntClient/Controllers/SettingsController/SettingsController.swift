//
//  SettingsController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 16.03.23.
//

import UIKit
import SnapKit
import SDWebImage

final class SettingsController: BaseController {
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    
    private lazy var scrollViewContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .purple
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload or change profile image:"
        label.numberOfLines = 0
        label.textColor = .purple
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.purple.cgColor
        imageView.layer.borderWidth = 5
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 125
        imageView.tintColor = .purple
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
        imageView.addGestureRecognizer(tabGesture)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .purple
        button.layer.cornerRadius = 8
        button.setTitle("Logout", for: .normal)
        button.addTarget(
            self,
            action: #selector(logoutButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        makeConstraint()
        setupData()
    }
    
}

extension SettingsController {
    
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(topContainerView)
        self.topContainerView.addSubview(titleLabel)
        self.contentView.addSubview(scrollView)
        self.scrollView.addSubview(scrollViewContentView)
        self.scrollViewContentView.addSubview(infoLabel)
        self.scrollViewContentView.addSubview(profileImageView)
        self.scrollViewContentView.addSubview(logoutButton)
    }
    
    private func makeConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        topContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topContainerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalTo(self.contentView)
        }
        
        scrollViewContentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(self.contentView)
        }
        
        let infoLabelInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        infoLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(infoLabelInsets)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(250)
        }
        
        let logoutButtomImsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(50)
            make.leading.trailing.bottom.equalToSuperview().inset(logoutButtomImsets)
            make.height.equalTo(40)
        }
        
    }
    
    private func setupData() {
        if let profileImageURL = UserDefaults.standard.object(forKey: "profileImageURL") as? String {
            self.profileImageView.sd_setImage(with: URL(string: profileImageURL))
        } else {
            self.profileImageView.image = UIImage(systemName: "person")
        }
    }
    
}

extension SettingsController {
    
    @objc private func logoutButtonDidTap() {
        UserDefaults.standard.set(nil, forKey: "accessToken")
        UserDefaults.standard.set(nil, forKey: "profileImageURL")
        Environment.sceneDelegate?.setLoginAsInitial()
    }
    
}

extension SettingsController {
    
    @objc private func imageViewDidTap() {
        showImagePickerOptions()
    }
    
    private func showImagePickerOptions() {
        let alertVC = UIAlertController(
            title: "Pick a photo",
            message: "Choose a picture from Library or camera",
            preferredStyle: .actionSheet
        )
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (action) in
            guard let self else { return }
            let cameraImagePicker = self.imagePicker(sourceType: .camera)
            cameraImagePicker.delegate = self
            self.present(cameraImagePicker, animated: true)
        }
        
        let libraryAction = UIAlertAction(title: "Library", style: .default) { [weak self] (action) in
            guard let self else { return }
            let libraryImagePicker = self.imagePicker(sourceType: .photoLibrary)
            libraryImagePicker.delegate = self
            self.present(libraryImagePicker, animated: true)
        }
        let cancelActon = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelActon)
        
        self.present(alertVC, animated: true)
    }
    
    private func imagePicker(sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        return imagePicker
    }
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        guard let imageData = image.pngData() else { return }
        
        TasteHuntProvider().addProfileImage(image: imageData) { [weak self] result in
            UserDefaults.standard.set(result.profileImageURL, forKey: "profileImageURL")
        } failure: { errorString in
            print(errorString)
        }
        
        self.profileImageView.image = image
        self.dismiss(animated: true)
    }
    
}
