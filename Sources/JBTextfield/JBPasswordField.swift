//
//  JBPasswordField.swift
//  JBTextfield
//
//  Created by Boaz James on 30/05/2025.
//

import UIKit

public class BasePasswordField: BaseTextfield {
    
    @IBInspectable public var passwordIconTintColor: UIColor = UIColor.labelColor {
        didSet {
            iconPasswordToggle.tintColor = passwordIconTintColor
        }
    }
    
    var iconPasswordToggle: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .labelColor
        view.contentMode = .scaleAspectFill
        view.applyAspectRatio(aspectRation: 1)
        view.image = UIImage(named: "show", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        view.isUserInteractionEnabled = true
        view.tag = 0
        return view
    }()
    
    override func setupView() {
        super.setupView()
        
        textfield.isSecureTextEntry = true
        
        iconPasswordToggle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTogglePassword)))
    }
    
    @objc private func handleTogglePassword() {
        if iconPasswordToggle.tag == 0 {
            textfield.isSecureTextEntry = false
            iconPasswordToggle.tag = 1
            iconPasswordToggle.image = UIImage(named: "hide", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        } else {
            textfield.isSecureTextEntry = true
            iconPasswordToggle.tag = 0
            iconPasswordToggle.image = UIImage(named: "show", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        }
    }
}

@IBDesignable
public class JBPasswordField: BasePasswordField {
    
    override func setupView() {
        super.setupView()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = keyboardType
        
        if style == .floating {
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
                labelLeadingConstraint,
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                labelHeightConstraint
            ])
            
            icon.applyAspectRatio(aspectRation: 1)
            NSLayoutConstraint.activate([
                icon.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
                icon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
                icon.widthAnchor.constraint(equalToConstant: 20)
            ])
            
            iconPasswordToggle.applyAspectRatio(aspectRation: 1)
            NSLayoutConstraint.activate([
                iconPasswordToggle.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
                iconPasswordToggle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
                iconPasswordToggle.widthAnchor.constraint(equalToConstant: 20)
            ])
            
            textfield.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
            NSLayoutConstraint.activate([
                textfield.heightAnchor.constraint(equalToConstant: 40),
                textfield.topAnchor.constraint(equalTo: label.centerYAnchor),
                textfield.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            lblError.pinToView(parentView: self, top: false)
            lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
            
        } else {
            addSubview(label)
            addSubview(textfield)
            addSubview(icon)
            addSubview(lblError)
            
            textfield.backgroundColor = boxBackgroundColor
            textfield.jbBorderColor = boxBorderColor
            textfield.jbBorderWidth = boxBorderWidth
            textfield.jbViewCornerRadius = boxCornerRadius
            
            labelHeightConstraint = label.heightAnchor.constraint(equalToConstant: 0)
            labelLeadingConstraint = label.leadingAnchor.constraint(equalTo: leadingAnchor)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: topAnchor),
                labelLeadingConstraint,
                label.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
            
            icon.applyAspectRatio(aspectRation: 1)
            NSLayoutConstraint.activate([
                icon.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
                icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                icon.widthAnchor.constraint(equalToConstant: 20)
            ])
            
            iconPasswordToggle.applyAspectRatio(aspectRation: 1)
            NSLayoutConstraint.activate([
                iconPasswordToggle.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
                iconPasswordToggle.trailingAnchor.constraint(equalTo: textfield.trailingAnchor, constant: -10),
                iconPasswordToggle.widthAnchor.constraint(equalToConstant: 20)
            ])
            
            textfield.pinToView(parentView: self, constant: 0, top: false, bottom: false)
            NSLayoutConstraint.activate([
                textfield.heightAnchor.constraint(equalToConstant: 50),
                textfield.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5)
            ])
            
            lblError.pinToView(parentView: self, top: false)
            lblError.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 4).activate()
        }
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 40)
        
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
        guard style == .floating else { return }
        
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
        guard style == .floating else { return }
        
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
            var myText: String {
                if textfield.keyboardType == .numberPad {
                    return text.onlyDigits()
                }
                
                return text
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
    }
    
    public override func hideError() {
        lblError.text = nil
        mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
        icon.tintColor = textfield.isFirstResponder ? highlightColor : .labelColor
        label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
    }
    
    override func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            if style == .floating {
                mainContainerView.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            } else {
                textfield.jbBorderColor = textfield.isFirstResponder ? highlightColor : strokeColor
            }
            icon.tintColor = textfield.isFirstResponder ? highlightColor : labelColor
            label.textColor = textfield.isFirstResponder ? highlightColor : labelColor
            secondaryLabel.textColor = textfield.isFirstResponder ? highlightColor : labelColor
        } else {
            if style == .floating {
                mainContainerView.jbBorderColor = errorColor
            } else {
                textfield.jbBorderColor = errorColor
            }
            icon.tintColor = errorColor
            label.textColor = errorColor
            secondaryLabel.textColor = errorColor
        }
        
        lblError.textColor = errorColor
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
        
//        textfield.addDoneButtonOnKeyboard(color: highlightColor)
    }
}

// Mark: UITextFieldDelegate
extension JBPasswordField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setupColors()
        if let text = textField.text {
            if text.isEmpty {
                showLabel()
            }
        } else {
            showLabel()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        setupColors()
        
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
        
        var myFullText: String {
            if textfield.keyboardType == .numberPad {
                return fullText.onlyDigits()
            }
            
            return fullText
        }
        
        if textfield.keyboardType == .numberPad && !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}

@IBDesignable
public class JBPlainPasswordField: BasePasswordField {
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
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.textfield.keyboardType = keyboardType
        textfield.textAlignment = textAlignment
        
        self.addSubview(textfield)
        self.addSubview(iconPasswordToggle)
        
        textfield.pinToView(parentView: self)
        textfieldMinWidthConstraint = textfield.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
        NSLayoutConstraint.activate([
            textfield.heightAnchor.constraint(equalToConstant: 40),
            textfieldMinWidthConstraint
        ])
        
        iconPasswordToggle.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            iconPasswordToggle.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
            iconPasswordToggle.trailingAnchor.constraint(equalTo: trailingAnchor),
            iconPasswordToggle.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        textfield.textPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        
        textfield.delegate = self
                
    }
    
    public override func setPlaceholder(_ placeholder: String) {
        super.setPlaceholder(placeholder)
        textfield.placeholder = placeholder
    }
    
    public override func setText(_ text: String) {
        if text.isEmpty {
            textfield.text = text
        } else {
            var myText: String {
                if textfield.keyboardType == .numberPad {
                    return text.onlyDigits()
                }
                
                return text
            }
            
            textfield.text = myText
        }
    }
    
    override func setupColors() {
        
        textfield.textColor = labelColor
        textfield.tintColor = highlightColor
        
//        textfield.addDoneButtonOnKeyboard(color: highlightColor)
    }
}

// Mark: UITextFieldDelegate
extension JBPlainPasswordField: UITextFieldDelegate {
    
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
        
        var myFullText: String {
            if textfield.keyboardType == .numberPad {
                return fullText.onlyDigits()
            }
            
            return fullText
        }
        
        if textfield.keyboardType == .numberPad && !myFullText.isNumeric() {
            return false
        }
        
        isDeleting = myFullText.count < currentText.count
                        
        return myFullText.count <= maxLength || maxLength == 0
    }
}
