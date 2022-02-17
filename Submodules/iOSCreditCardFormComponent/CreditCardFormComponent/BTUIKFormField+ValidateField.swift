//
//  BTUIKFormField+ValidateField.swift
//  CreditCardFormComponent
//
//  Created by Ron on 09/02/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import Foundation
import BraintreeUIKit

extension BTUIKFormField {
    open func validate() {
        // Validation happens when ending editing
        textFieldDidEndEditing(self.textField)
    }
}

struct FormFieldHelper {
    static func stripInvalidAccessibility(fromString string: String?) -> String? {
        return string?.replacingOccurrences(of: "Invalid: ", with: "")
    }
    
    static func addInvalidAccessibility(toString string: String?) -> String? {
        guard let stripped = stripInvalidAccessibility(fromString: string) else { return nil }
        return "Invalid: \(stripped)"
    }
    
    static func updateAppearance<T: BTUIKFormField & IFormFieldWithTextFieldFont>(ofField field: T) {
        var textColor: UIColor?
        let currentAccessibilityLabel: String? = field.textField.accessibilityLabel
        if !field.displayAsValid {
            textColor = BTUIKAppearance.sharedInstance().errorForegroundColor;
            if currentAccessibilityLabel != nil {
                field.textField.accessibilityLabel = addInvalidAccessibility(toString: currentAccessibilityLabel)
            }
        } else {
            textColor = BTUIKAppearance.sharedInstance().primaryTextColor;
            if (currentAccessibilityLabel != nil) {
                field.textField.accessibilityLabel = stripInvalidAccessibility(fromString: currentAccessibilityLabel)
            }
        }
        
        let mutableText = NSMutableAttributedString(attributedString: field.textField.attributedText ?? NSMutableAttributedString())
        
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.foregroundColor] = textColor ?? .black
        attributes[NSAttributedString.Key.font] = field.textFieldFont
        
        mutableText.addAttributes(attributes, range: NSMakeRange(0, mutableText.length))
        
        let currentRange = field.textField.selectedTextRange
        
        field.textField.attributedText = mutableText;
        
        // Reassign current selection range, since it gets cleared after attributedText assignment
        field.textField.selectedTextRange = currentRange;
    }
}

public protocol IFormFieldWithTextFieldFont: class {
    var textFieldFont: UIFont? { get set }
}
