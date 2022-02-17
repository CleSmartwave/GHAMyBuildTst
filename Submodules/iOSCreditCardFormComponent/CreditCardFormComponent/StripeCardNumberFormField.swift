//
//  StripeCardNumberFormField.swift
//  CreditCardFormComponent
//
//  Created by Pat Osorio on 9/26/19.
//  Copyright © 2019 genie. All rights reserved.
//

import Foundation
import Stripe
public class StripeCardNumberFormField: UITextField {
    public var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    public var isValid: Bool {
        if let fieldText = text, fieldText.isEmpty {
            return false
        } else if STPCardValidator.validationState(forNumber: self.text ?? "",
                                            validatingCardBrand: true).rawValue == 1 {
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
