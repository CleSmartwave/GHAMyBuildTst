//
//  BTUIKCardNumberFormField+NoTextTransform.swift
//  CreditCardFormComponent
//
//  Created by Ron on 07/02/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import Foundation
import UIKit
import BraintreeUIKit

public class GenieCardNumberFormField: BTUIKCardNumberFormField, IFormFieldWithTextFieldFont {
    
    public lazy var textFieldFont: UIFont? = {
        return UIFont(name: BTUIKAppearance.sharedInstance().fontFamily,
                      size: UIFont.labelFontSize)
    }()

    public override func updateAppearance() {
        FormFieldHelper.updateAppearance(ofField: self)
    }
    
    public override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)

        showCardHintAccessory()
    }

    override public func textFieldDidEndEditing(_ textField: UITextField) {
        let origText = NSMutableAttributedString(attributedString: self.textField.attributedText!)

        super.textFieldDidEndEditing(textField)
        formLabel.text = nil
        
        // Seems that setting an attribute would
        // make the text not go into right aligment on
        // iOS 11 below
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .right
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: titleParagraphStyle,
        ]

        let textRange = NSMakeRange(0, origText.length)
        origText.addAttributes(attributes, range: textRange)

        origText.addAttribute(.foregroundColor, value: self.textField.textColor!, range: textRange)
        self.textField.attributedText = origText

        updateConstraints()
        showCardHintAccessory()
    }
}
