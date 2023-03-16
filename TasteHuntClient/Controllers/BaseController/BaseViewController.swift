//
//  BaseViewController.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 11.03.23.
//

import UIKit
import SnapKit

class BaseController: UIViewController {
    
    private lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        makeConstraint()
        setBackground(.gray)
    }
    
    private func setupLayout() {
        self.view.addSubview(mainView)
        self.mainView.addSubview(contentView)
    }
    
    private func makeConstraint() {
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func setBackground(_ type: BackgroundType) {
        self.mainView.backgroundColor = type.color
    }
    
}

// MARK: -
// MARK: Navigation
extension BaseController {
    
    func push(_ vc: UIViewController, animated: Bool = false) {
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func popToRoot(animated: Bool = false) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
}

// MARK: -
// MARK: KeyboardObservers
extension BaseController {
    
    func subscribeKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisply),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func unsubscribeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc func keyboardWillDisply(notifications: Notification) { }
    
    @objc func keyboardHide() { }
    
}


