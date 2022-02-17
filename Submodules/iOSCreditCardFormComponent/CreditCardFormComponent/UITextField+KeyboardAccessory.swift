//
//  UITextField+KeyboardAccessory.swift
//  CreditCardFormComponent
//
//  Created by Ron on 07/02/2018.
//  Copyright © 2018 genie. All rights reserved.
//

import Foundation

fileprivate struct UITextFieldDoneToolbarHelper {
    fileprivate static var allToolbars: NSMapTable =
        NSMapTable<UITextField, UIToolbar>(keyOptions: .weakMemory,
                                           valueOptions: .weakMemory)
    
    fileprivate static func addDoneButtonOnKeyboard(to textField: UITextField) {
        guard UITextFieldDoneToolbarHelper.allToolbars.object(forKey: textField) == nil
            else { return }
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0,
                                                                  y: 0,
                                                                  width: UIScreen.main.bounds.width,
                                                                  height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil,
                                        action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "done",
                                                    style: .done,
                                                    target: textField,
                                                    action: #selector(textField.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        UITextFieldDoneToolbarHelper.allToolbars.setObject(doneToolbar, forKey: textField)
        
        textField.inputAccessoryView = doneToolbar
    }
    
    fileprivate static func removeDoneButtonOnKeyboard(from textField: UITextField) {
        guard let toolbar = UITextFieldDoneToolbarHelper.allToolbars.object(forKey: textField)
            else { return }
        
        if textField.inputAccessoryView == toolbar {
            textField.inputAccessoryView = nil
        }
    }
    
    private init() {}
}

extension UITextField {
    var showDoneAccessory: Bool {
        get {
            return UITextFieldDoneToolbarHelper.allToolbars.object(forKey: self) != nil
        }
        set (showDone) {
            if showDone {
                UITextFieldDoneToolbarHelper.addDoneButtonOnKeyboard(to: self)
            } else {
                UITextFieldDoneToolbarHelper.removeDoneButtonOnKeyboard(from: self)
            }
        }
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}
