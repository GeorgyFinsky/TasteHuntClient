//
//  LoginViewController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 11.03.23.
//

import UIKit
import SnapKit

final class LoginController: BaseController {
    
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
        label.text = "Authorization"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 32)
        return label
    }()
    
    private lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter your phone number and password:"
        label.numberOfLines = 0
        label.textColor = .purple.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private lazy var usernameField: UITextField = {
        let field = createField(.name)
        field.placeholder = "Username"
        field.addTarget(
            self,
            action: #selector(usernameFieldDidEndEdditing),
            for: .editingDidEnd
        )
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = createField(.password)
        field.placeholder = "Password"
        field.addTarget(
            self,
            action: #selector(passwordFieldDidEndEdditing),
            for: .editingDidEnd
        )
        return field
    }()
    
    private lazy var loginButton: UIButton = {
        let button = createButton(isLogin: true)
        button.setTitle("Login", for: .normal)
        button.addTarget(
            self,
            action: #selector(loginButtonDidTap),
            for: .touchUpInside
        )
        button.isEnabled = false
        return button
    }()
    
    private lazy var registrationButton: UIButton = {
        let button = createButton(isLogin: false)
        button.setTitle("Registration", for: .normal)
        button.addTarget(
            self,
            action: #selector(registrationButtonDidTap),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var scrollContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: -
    // MARK: Lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.subscribeKeyboardObservers()
        setupLayout()
        makeConstraint()
    }
    
    deinit {
        unsubscribeKeyboardObservers()
    }
    
}

// MARK: -
// MARK: SetupUI
extension LoginController {
    
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
        return field
    }
    
    private func createButton(isLogin: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.tintColor = isLogin ? .white : .purple
        button.backgroundColor = isLogin ? .purple : .lightGray
        button.layer.cornerRadius = 12
        return button
    }
    
    private func setupLayout() {
        self.view.addSubview(topContainerView)
        self.contentView.addSubview(informationLabel)
        self.contentView.addSubview(usernameField)
        self.contentView.addSubview(passwordField)
        self.contentView.addSubview(scrollView)
        self.scrollView.addSubview(scrollContentView)
        self.scrollContentView.addSubview(loginButton)
        self.scrollContentView.addSubview(registrationButton)
        self.topContainerView.addSubview(titleLabel)
    }
    
    private func makeConstraint() {
        topContainerView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(self.view.frame.height * 0.18)
        }
        
        let titleLabelEdges = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        titleLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(titleLabelEdges)
        }
        
        let informationLabelEdges = UIEdgeInsets(top: 40, left: 30, bottom: 50, right: 30)
        informationLabel.snp.makeConstraints { make in
            make.top.equalTo(topContainerView.snp.bottom).offset(informationLabelEdges.top)
            make.leading.trailing.equalToSuperview().inset(informationLabelEdges)
        }
        
        let fieldEdges = UIEdgeInsets(top: 70, left: 30, bottom: 20, right: 30)
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(informationLabel.snp.bottom).offset(fieldEdges.top)
            make.leading.trailing.equalToSuperview().inset(fieldEdges)
            make.height.equalTo(40)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(fieldEdges.bottom)
            make.leading.trailing.equalToSuperview().inset(fieldEdges)
            make.height.equalTo(40)
        }
        
        let buttonsInsets = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        registrationButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(buttonsInsets)
            make.height.equalTo(40)
        }
        
        loginButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(buttonsInsets)
            make.height.equalTo(40)
            make.bottom.equalTo(registrationButton.snp.top).inset(-buttonsInsets.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalTo(scrollView)
        }
    }
    
}

// MARK: -
// MARK: Observers selector
extension LoginController {
    
    override func keyboardWillDisply(notifications: Notification) {
        guard let  keyboardFrame:NSValue = notifications.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardRectangleHeight = keyboardFrame.cgRectValue.height
        let buttonBottomInset = self.view.safeAreaInsets.bottom + 70
        
        scrollView.contentOffset = CGPoint(
            x: 0,
            y: keyboardRectangleHeight - buttonBottomInset
        )
    }
    
    override func keyboardHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
}

// MARK: -
// MARK: UITextFields Validation
extension LoginController {
    
    @objc private func passwordFieldDidEndEdditing(sender: UITextField) {
        sender.layer.borderColor = sender.isValid(.password) ? UIColor.lightGray.cgColor : UIColor.red.cgColor
        isLoginButtonEnabled()
    }
    
    @objc private func usernameFieldDidEndEdditing(sender: UITextField) {
        sender.layer.borderColor = sender.isValid(.name) ? UIColor.lightGray.cgColor : UIColor.red.cgColor
        isLoginButtonEnabled()
    }
    
    private func isLoginButtonEnabled() {
        if passwordField.isValid(.password), usernameField.isValid(.name) {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }
    
}

// MARK: -
// MARK: Buttons Action
extension LoginController {
    
    @objc private func loginButtonDidTap() {
        TasteHuntProvider().loginUser(username: usernameField.text!, password: passwordField.text!) { [weak self] result in
            guard let self else { return }
            UserDefaults.standard.set(result.token, forKey: "accessToken")
            Environment.sceneDelegate?.setTabbarAsInitial()
        } failure: { errorString in
            print(errorString)
        }
    }
    
    @objc private func registrationButtonDidTap() {
        self.push(ControllersList.registration.vc, animated: true)
    }
    
}
