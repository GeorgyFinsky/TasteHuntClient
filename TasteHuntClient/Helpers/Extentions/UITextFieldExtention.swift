//
//  UITextFieldExtention.swift
//  TasteHuntClient
//
//  Created by Georgy Finsky on 11.03.23.
//

import UIKit

extension UITextField {
        
    func isValid(_ pattern: TextFieldType) -> Bool {
        guard let text = self.text else { return false }
        let passPred = NSPredicate(format: "SELF MATCHES %@", pattern.validationString)
        return passPred.evaluate(with: text)
    }
    
}
