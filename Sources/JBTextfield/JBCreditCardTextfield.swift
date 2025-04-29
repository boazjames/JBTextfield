//
//  File.swift
//  JBTextfield
//
//  Created by Boaz James on 29/04/2025.
//

import UIKit

@IBDesignable
public class JBCreditCardTextfield: BaseTextfield {
    
    public var finalText: String {
        return cleanPAN(PAN: textfield.text ?? "")
    }
    
    public var isCreditCardNumberValid: Bool {
        return finalText.count == creditCardMaxLength
    }
    
    private let creditCardMaxLength = 16
    
    override func setupView() {
        super.setupView()
        
        maxLength = 16
        
        textfield.textContentType = .creditCardNumber
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = .numberPad
        
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
            let myText = String(cleanPAN(PAN: text.removeSpaces()).prefix(creditCardMaxLength))
            textfield.text = myText.grouping(every: 4, with: "-")
            
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
        
        let myText = text.isEmpty ? text : cleanPAN(PAN: text.removeSpaces()).grouping(every: 4, with: "-")
                
        if myText != text {
            self.textfield.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
}

// Mark: UITextFieldDelegate
extension JBCreditCardTextfield: UITextFieldDelegate {
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
        
        let myFullText = cleanPAN(PAN: fullText)
        
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= creditCardMaxLength || creditCardMaxLength == 0
    }
}

@IBDesignable
public class JBPlainCreditCardTextfield: BaseTextfield {
    
    public var finalText: String {
        return cleanPAN(PAN: textfield.text ?? "")
    }
    
    public var isCreditCardNumberValid: Bool {
        return finalText.count == creditCardMaxLength
    }
    
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
    
    private let creditCardMaxLength = 16
    
    override func setupView() {
        super.setupView()
        
        maxLength = 16
        
        textfield.textContentType = .creditCardNumber
        
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
            let myText = String(cleanPAN(PAN: text.removeSpaces()).prefix(creditCardMaxLength))
            textfield.text = myText.grouping(every: 4, with: "-")
        }
    }
    
    override func setupColors() {
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
    }
    
    public override func textDidChange(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        let myText = text.isEmpty ? text : cleanPAN(PAN: text.removeSpaces()).grouping(every: 4, with: "-")
                
        if myText != text {
            self.textfield.text = myText
        }
        
        hideError()
        
        delegate?.textDidChange?(textField: sender)
    }
}

// Mark: UITextFieldDelegate
extension JBPlainCreditCardTextfield: UITextFieldDelegate {
    
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
        
        let myFullText = cleanPAN(PAN: fullText)
        
        if !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= creditCardMaxLength || creditCardMaxLength == 0
    }
}
