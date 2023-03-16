//
//  RegistrationViewController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 11.03.23.
//

import UIKit
import SnapKit

final class RegistrationController: BaseController {
    
    // MARK: -
    // MARK: UIObjects
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration"
        label.textColor = .purple
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .purple
        return progress
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.tintColor = .white
        button.backgroundColor = .purple
        button.layer.cornerRadius = 12
        button.isEnabled = false
        button.addTarget(
            self,
            action: #selector(nextButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var usernameField: UITextField = {
        let field = createField(.name)
        field.placeholder = "Create You Username"
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = createField(.password)
        field.placeholder = "Create Password"
        return field
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Please select You Favorite Dishes:"
        label.numberOfLines = 0
        label.textColor = .purple.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collection = UICollectionView(
            frame: CGRect(),
            collectionViewLayout: layout
        )
        collection.collectionViewLayout = layout
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    private lazy var profileView = createView()
    private lazy var kitchensSelectView = createView()
    
    private let kitchens = KitchensType.allCases
    private var selectedKitchens = [IndexPath]()
    private var registrationViews = [UIView]()
    private var profileViewContent = [UITextField]()
    private var currentViewIndex = 0
    private var userID: String?
    private var isUsernameEnabled: Bool = false
    var loginBlock: ((GuestModel) -> ())?
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.subscribeKeyboardObservers()
        registerCell()
        setupLayout()
        makeConstraint()
    }
    
    deinit {
        unsubscribeKeyboardObservers()
    }
    
    private func registerCell() {
        collectionView.register(
            SelectKitchenCoollectionViewCell.self,
            forCellWithReuseIdentifier: SelectKitchenCoollectionViewCell.id
        )
    }
    
}

// MARK: -
// MARK: SetupUI
extension RegistrationController {
    
    private func createView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.purple.cgColor
        view.layer.borderWidth = 2
        return view
    }
    
    private func createField(_ type: TextFieldType) -> UITextField {
        let field = UITextField()
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 8
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: field.frame.height))
        field.leftViewMode = .always
        field.tintColor = .purple
        field.keyboardType = type.keyboardType
        field.autocorrectionType = type.isAutoCorrectionEnabled ? .yes : .no
        field.isSecureTextEntry = type.isSecurityEnteryEnabled
        field.addTarget(
            self,
            action: #selector(fieldValidation(sender:)),
            for: .editingDidEnd)
        return field
    }
    
    private func setupLayout() {
        self.navigationItem.titleView = titleLabel
        self.registrationViews = [profileView, kitchensSelectView]
        self.profileViewContent = [usernameField, passwordField]
        
        self.contentView.addSubview(progressView)
        self.contentView.addSubview(kitchensSelectView)
        self.contentView.addSubview(profileView)
        self.contentView.addSubview(nextButton)
        self.kitchensSelectView.addSubview(infoLabel)
        self.kitchensSelectView.addSubview(collectionView)
        
        profileViewContent.forEach { field in
            self.profileView.addSubview(field)
        }
    }
    
    private func makeConstraint() {
        let progressViewEdges = UIEdgeInsets(top: 20, left: 30, bottom: 30, right: 30)
        progressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(progressViewEdges)
        }
        
        let nextButtonEdges = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.bottom.equalToSuperview().inset(nextButtonEdges)
        }
        
        self.registrationViews.forEach { view in
            view.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(progressView.snp.bottom).offset(30)
                make.bottom.equalTo(nextButton.snp.top).offset(-30)
                make.width.equalTo(self.view.bounds.width * 0.85)
            }
        }
        
        makeFieldsConstraint(fields: profileViewContent)
        
        let infoLabelEdges = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        infoLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(infoLabelEdges)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func makeFieldsConstraint(fields: [UITextField]) {
        let fieldEdges = UIEdgeInsets(top: 30, left: 16, bottom: 20, right: 16)
        var previousTextField: UITextField?
        
        fields.forEach { field in
            field.snp.makeConstraints { make in
                if let previousTextField {
                    make.top.equalTo(previousTextField.snp.bottom).offset(fieldEdges.top)
                } else {
                    make.top.equalToSuperview().offset(50)
                }
                make.leading.trailing.equalToSuperview().inset(fieldEdges)
                make.height.equalTo(40)
            }
            previousTextField = field
        }
    }
    
    private func makeNextButtonConstraints(keyboardHeight: Double? = nil) {
        let nextButtonEdges = UIEdgeInsets(
            top: 20,
            left: 30,
            bottom: keyboardHeight != nil ? CGFloat(keyboardHeight!) : 20,
            right: 30
        )
        nextButton.snp.remakeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.bottom.equalToSuperview().inset(nextButtonEdges)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func updateProgressView() {
        let progress = Float(currentViewIndex) / Float(registrationViews.count)
        progressView.setProgress(progress, animated: true)
    }
    
}

// MARK: -
// MARK: Buttons Action
extension RegistrationController {
    
    @objc private func nextButtonDidTap() {
        let animationDuration: TimeInterval = 0.5
        registerUser()
        
        if currentViewIndex == 0 {
            currentViewIndex = 1
            updateProgressView()
            
            profileView.snp.remakeConstraints { make in
                make.top.equalTo(progressView.snp.bottom).offset(30)
                make.bottom.equalTo(nextButton.snp.top).offset(-30)
                make.width.equalTo(self.view.bounds.width * 0.85)
                make.trailing.equalTo(contentView.snp.leading)
            }
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            } completion: { isFinish in
                guard isFinish else { return }
                
                self.profileView.alpha = 0
                self.nextButton.setTitle("Register", for: .normal)
            }
        } else {
            addUserKitchens()
            self.dismiss(animated: true)
        }
    }
    
    private func registerUser() {
        TasteHuntProvider().registerGuest(
            id: UUID(),
            username: usernameField.text!,
            password: passwordField.text!,
            profileImageURL: "",
            kitchens: "",
            visits: "") { [weak self] result in
                guard let self else { return }
                self.userID = result.id.uuidString
                self.loginBlock?(result)
            } failure: { errorString in
                print(errorString)
            }
    }
    
    private func addUserKitchens() {
    }
    
}

// MARK: -
// MARK: Observers selector
extension RegistrationController {
    
    override func keyboardWillDisply(notifications: Notification) {
        guard let  keyboardFrame:NSValue = notifications.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangleHeight = keyboardFrame.cgRectValue.height
        
        makeNextButtonConstraints(keyboardHeight: keyboardRectangleHeight)
    }
    
    override func keyboardHide() {
        makeNextButtonConstraints()
    }
    
}

// MARK: -
// MARK: UITextFields Validation
extension RegistrationController {
    
    @objc private func fieldValidation(sender: UITextField) {
        var validationType: TextFieldType = .none
        
        switch sender {
            case usernameField:
                validationType = .name
                if let text = sender.text {
                    TasteHuntProvider().isUsernameExist(username: text) { [weak self] result in
                        guard let self else { return }
                        
                        self.isUsernameEnabled = result.isExist ? false : true
                    } failure: { errorString in
                        print(errorString)
                    }
                }
            case passwordField:
                validationType = .password
            default: break
        }
        sender.layer.borderColor = sender.isValid(validationType) ? UIColor.lightGray.cgColor : UIColor.red.cgColor
        sender.layer.borderColor = isUsernameEnabled ? UIColor.lightGray.cgColor : UIColor.red.cgColor
        
        isNextButtonEnabled()
    }
    
    private func isNextButtonEnabled() {
        if usernameField.isValid(.name), passwordField.isValid(.password), isUsernameEnabled {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
}

// MARK: -
// MARK: UICollectionViewDelegate
extension RegistrationController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedKitchens.append(indexPath)
        collectionView.reloadData()
    }
    
}

// MARK: -
// MARK: UICollectionViewDataSource
extension RegistrationController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return kitchens.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectKitchenCoollectionViewCell.id,
            for: indexPath
        ) as! SelectKitchenCoollectionViewCell
        selectedKitchens.forEach { $0 == indexPath ? cell.isSelected = true : nil }
        
        cell.set(value: kitchens[indexPath.row])
        return cell
    }
    
}

// MARK: -
// MARK: UICollectionViewDelegateFlowLayout
extension RegistrationController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset = 10.0
        let contentViewWidth = self.kitchensSelectView.bounds.width
        let wight = (contentViewWidth - (inset * 3)) / 2
        return CGSize(width: wight, height: wight)
    }
    
}
