//
//  StripeExpiryFormField.swift
//  CreditCardFormComponent
//
//  Created by Pat Osorio on 9/26/19.
//  Copyright © 2019 genie. All rights reserved.
//

import Foundation
import Stripe

public class StripeExpiryFormField: UITextField {
    fileprivate struct Constants {
        static let expiryDateSeparator: Character = "/"
    }
    
    public var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    var expiryYear: String? {
        get {
            if let year = self.text?.split(separator: Constants.expiryDateSeparator).last {
                return String(year.suffix(2))
            }
            return nil
        }
    }
    
    var expiryMonth: String? {
        get {
            if let month = self.text?.split(separator: Constants.expiryDateSeparator).first {
                return String(month)
            }
            return nil
        }
    }
    
    public var isValid: Bool {
        if let fieldText = text, fieldText.isEmpty {
            return false
        } else if STPCardValidator.validationState(forExpirationYear: expiryYear ?? "", inMonth: expiryMonth ?? "").rawValue == 1 {
            return false
        }
        return true
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
