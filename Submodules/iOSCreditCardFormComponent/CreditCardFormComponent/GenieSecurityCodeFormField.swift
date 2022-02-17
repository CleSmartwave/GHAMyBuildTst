//
//  GenieSecurityCodeFormField.swift
//  CreditCardFormComponent
//
//  Created by user1 on 15/08/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import Foundation
import UIKit
import BraintreeUIKit

public class GenieSecurityCodeFormField: BTUIKSecurityCodeFormField, IFormFieldWithTextFieldFont {
    
    public lazy var textFieldFont: UIFont? = {
        return UIFont(name: BTUIKAppearance.sharedInstance().fontFamily,
                      size: UIFont.labelFontSize)
    }()
    
    public override func updateAppearance() {
        FormFieldHelper.updateAppearance(ofField: self)
    }
    
}
