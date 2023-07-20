//
//  File.swift
//  
//
//  Created by Boaz James on 20/07/2023.
//

import UIKit

extension UITextField {
    func addDoneButtonOnKeyboard(color: UIColor) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self, action: #selector(resignFirstResponder))
        doneButton.tintColor = color
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}
