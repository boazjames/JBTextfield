//
//  JBCreditCardExpiryDateTextfield.swift
//  JBTextfield
//
//  Created by Boaz James on 29/04/2025.
//

import UIKit

@IBDesignable
public class JBCreditCardExpiryDateTextfield: BaseTextfield {
    public var isDateValid: Bool {
        return Date.parseCreditCardExpiryDate(dateString: text) != nil
    }
    
    public var hasCreditCardExpired: Bool {
        if let date = Date.parseCreditCardExpiryDate(dateString: text) {
            let now = Date()
            
            if let now = Date.parseCreditCardExpiryDate(dateString: now.creditCardExpiryDateFormat()) {
                return date < now
            }
        }
        
        return true
    }
    
    private let expiryDateMaxLength = 4
    
    override func setupView() {
        super.setupView()
                
        if #available(iOS 17.0, *) {
            textfield.textContentType = .creditCardSecurityCode
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = .numberPad
        
        setPlaceholder("Expiry Date".localized)
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(textfield)
        containerView.addSubview(label)
        containerView.addSubview(icon)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        mainContainerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        containerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor).activate()
        
        labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
        labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10),
            labelHeightConstraint,
            labelLeadingConstraint
        ])
        
        icon.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            icon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        textfield.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfield.topAnchor.constraint(equalTo: label.centerYAnchor),
            textfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        textfield.delegate = self
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
        label.text = placeholder
    }
    
    public override func setPlaceholder(_ placeholder: String, labelText: String) {
        super.setPlaceholder(placeholder, labelText: labelText)
        textfield.placeholder = placeholder
        label.text = labelText
    }
    
    private func showLabel() {
        self.layoutIfNeeded()
        let originY = label.frame.origin.y
        let distance: CGFloat = 20
        label.frame.origin.y = originY + distance
        
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.deactivate()
            self.label.frame.origin.y = originY
            self.layoutIfNeeded()
        }
    }
    
    private func hideLabel() {
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.activate()
            self.layoutIfNeeded()
        }
    }
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
            label.textColor = labelColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            var myText = String(cleanCreditCardExpiryDate(text: text.removeSpaces()).prefix(maxLength - 1))
            
            if myText.count > 1 {
                myText.insert("/", at: myText.index(myText.startIndex, offsetBy: 2))
            }
            textfield.text = myText
            
            label.textColor = labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
    }
    
    public override func showError(_ message: String, focusOnField: Bool = false) {
        lblError.text = message
        
        if focusOnField {
            textfield.becomeFirstResponder()
        }
        
        mainContainerView.jbBorderColor = errorColor
        icon.tintColor = errorColor
        label.textColor = errorColor
        secondaryLabel.textColor = errorColor
    }
    
    public override func hideError() {
        lblError.text = nil
        mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
        icon.tintColor = textfield.isFirstResponder ? highlightColor : .labelColor
        label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        secondaryLabel.textColor = textfield.isFirstResponder ? highlightColor : labelColor
    }
    
    override func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            icon.tintColor = textfield.isFirstResponder ? highlightColor : labelColor
            label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        } else {
            mainContainerView.jbBorderColor = errorColor
            icon.tintColor = errorColor
            label.textColor = errorColor
        }
        
        label.textColor = labelColor
        lblError.textColor = errorColor
        secondaryLabel.textColor = labelColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
    }
    
    public override func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        if text.isEmpty {
            self.textfield.text = text
            return
        }
        
        var myText = String(cleanCreditCardExpiryDate(text: text.removeSpaces()))
        
        if text.removeSpaces().count == 2 && isDeleting {
            self.textfield.text = String(myText.prefix(1))
            return
        }
        
        if myText.count > 1 {
            myText.insert("/", at: myText.index(myText.startIndex, offsetBy: 2))
        }
        
        if myText != text {
            self.textfield.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
}

// Mark: UITextFieldDelegate
extension JBCreditCardExpiryDateTextfield: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        label.textColor = isErrorTextEmpty ? highlightColor : errorColor
        secondaryLabel.textColor = isErrorTextEmpty ? highlightColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? highlightColor : errorColor
        icon.tintColor = isErrorTextEmpty ? highlightColor : errorColor
        if let text = textField.text {
            if text.isEmpty {
                showLabel()
            }
        } else {
            showLabel()
        }
        
        textField.placeholder = "MM/YY"
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        label.textColor = isErrorTextEmpty ? labelColor : errorColor
        secondaryLabel.textColor = isErrorTextEmpty ? labelColor : errorColor
        mainContainerView.jbBorderColor = isErrorTextEmpty ? strokeColor : errorColor
        icon.tintColor = isErrorTextEmpty ? labelColor : errorColor
        
        if let text = textField.text {
            if text.isEmpty {
                hideLabel()
            }
        } else {
            hideLabel()
        }
        
        textField.placeholder = placehodler
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        var fullText: String {
            if string.isEmpty {
                var text = currentText
                guard let myRange = Range(range, in: currentText) else { return text}
                text.replaceSubrange(myRange, with: string)
                
                return text
            }
            
            return "\(currentText)\(string)"
        }
        
        if fullText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        
        let myFullText = cleanCreditCardExpiryDate(text: fullText)
        
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= expiryDateMaxLength || expiryDateMaxLength == 0
    }
}

@IBDesignable
public class JBPlainCreditCardExpiryDateTextfield: BaseTextfield {
    public var isDateValid: Bool {
        return Date.parseCreditCardExpiryDate(dateString: text) != nil
    }
    
    public var hasCreditCardExpired: Bool {
        if let date = Date.parseCreditCardExpiryDate(dateString: text) {
            let now = Date()
            
            if let now = Date.parseCreditCardExpiryDate(dateString: now.creditCardExpiryDateFormat()) {
                return date > now
            }
        }
        
        return true
    }
    
    private let expiryDateMaxLength = 4
    
    public var minWidth: CGFloat = 100 {
        didSet {
            textfieldMinWidthConstraint.constant = minWidth
        }
    }
    
    public var textAlignment: NSTextAlignment = .right {
        didSet {
            textfield.textAlignment = textAlignment
        }
    }
    
    private var textfieldMinWidthConstraint: NSLayoutConstraint!
    
    override func setupView() {
        super.setupView()
                
        if #available(iOS 17.0, *) {
            textfield.textContentType = .creditCardSecurityCode
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = .numberPad
        textfield.textAlignment = textAlignment
        
        self.addSubview(textfield)
        
        textfield.pinToView(parentView: self)
        textfieldMinWidthConstraint = textfield.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfieldMinWidthConstraint
        ])
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        textfield.delegate = self
        
        setPlaceholder("Expiry Date".localized)
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
    }
    
    public override func setPlaceholder(_ placeholder: String, labelText: String) {
        super.setPlaceholder(placeholder, labelText: labelText)
        textfield.placeholder = placeholder
    }
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
        } else {
            var myText = String(cleanCreditCardExpiryDate(text: text.removeSpaces()).prefix(maxLength - 1))
            
            if myText.count > 1 {
                myText.insert("/", at: myText.index(myText.startIndex, offsetBy: 2))
            }
            textfield.text = myText
        }
    }
    
    override func setupColors() {
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
    }
    
    public override func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        if text.isEmpty {
            self.textfield.text = text
            return
        }
        
        var myText = String(cleanCreditCardExpiryDate(text: text.removeSpaces()))
        
        if text.removeSpaces().count == 2 && isDeleting {
            self.textfield.text = String(myText.prefix(1))
            return
        }
        
        if myText.count > 1 {
            myText.insert("/", at: myText.index(myText.startIndex, offsetBy: 2))
        }
        
        if myText != text {
            self.textfield.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
}

// Mark: UITextFieldDelegate
extension JBPlainCreditCardExpiryDateTextfield: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "MM/YY"
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = placehodler
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        var fullText: String {
            if string.isEmpty {
                var text = currentText
                guard let myRange = Range(range, in: currentText) else { return text}
                text.replaceSubrange(myRange, with: string)
                
                return text
            }
            
            return "\(currentText)\(string)"
        }
        
        if fullText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        
        let myFullText = cleanCreditCardExpiryDate(text: fullText)
        
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= expiryDateMaxLength || expiryDateMaxLength == 0
    }
}
