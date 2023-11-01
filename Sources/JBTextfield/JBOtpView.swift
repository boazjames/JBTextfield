//
//  File.swift
//  
//
//  Created by Boaz James on 21/07/2023.
//

import UIKit

public class OtpTextField: CustomTextField {
    
    public var customDelegate: MyTextFieldDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
//        self.applyAspectRatio(aspectRation: 1)
        
        self.textColor = .labelColor
        
        self.font = .systemFont(ofSize: 25)
        self.textAlignment = .center
        self.keyboardType = .numberPad
        
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0
        
        self.isPasteEnabled = false
        self.isSelectEnabled = false
        self.isSelectAllEnabled = false
        self.isCopyEnabled = false
        self.isCutEnabled = false
        self.isDeleteEnabled = false
    }
    
    public override func deleteBackward() {
        let wasEmpty = text == nil || text!.isEmpty
                
        self.text = ""
        
//        super.deleteBackward()
                
        customDelegate?.textField(self, didDeleteBackwardAnd: wasEmpty)
        
    }
}

@IBDesignable
class OtpView: UIView {
    var text: String? {
        get {
            return textField.text
        }
        
        set(value) {
            textField.text = value
        }
    }
        
    private(set) var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = 5
        return view
    } ()
    
    private(set) var textField: OtpTextField = {
        let view = OtpTextField()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 5
        return view
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
//        self.applyAspectRatio(aspectRation: 1)
        self.heightAnchor.constraint(equalToConstant: 60).activate()
        
        self.layer.borderColor = UIColor.strokeColor.cgColor
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        
        self.addSubview(textField)
        self.addSubview(overlayView)
        
        textField.pinToView(parentView: self)
        overlayView.pinToView(parentView: self)
        
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.focusOnTextField)))
                
    }
    
    @objc func focusOnTextField() {
        self.textField.becomeFirstResponder()
    }
    
    @objc func unfocusTextField() {
        self.textField.resignFirstResponder()
    }
    
    func deleteBackward() {
        textField.deleteBackward()
    }
}

public protocol MyTextFieldDelegate: UITextFieldDelegate {
    func textField(_ textField: UITextField, didDeleteBackwardAnd wasEmpty: Bool)
}

@IBDesignable
public class JBOtpEntryView: UIStackView {
    var delegate: OtpEntryDelegate?
    
    @IBInspectable public var enableUserInteraction = true {
        didSet {
            setupuserInteraction()
        }
    }
    
    private(set) var text = "" {
        didSet {
            if text.count == length {
                self.endEditing(true)
                delegate?.didEnterFullOtpCode(didEnter: text)
            }
        }
    }
    
    @IBInspectable public var length = 6 {
        didSet {
            setupOtpViews()
        }
    }
    
    @IBInspectable public var interItemSpacing: CGFloat = 5 {
        didSet {
            self.spacing = interItemSpacing
        }
    }
    
    private var otpViews: [OtpView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        setupOtpViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupOtpViews()
    }
    
    init(length: Int = 4, interItemSpacing: CGFloat = 20, enableUserInteraction: Bool = true) {
        super.init(frame: CGRect.zero)
        self.length = length
        self.interItemSpacing = interItemSpacing
        setup()
        setupOtpViews()
    }
    
    private func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.alignment = .fill
        self.distribution = .fillEqually
        self.axis = .horizontal
        self.spacing = self.interItemSpacing
        
    }
    
    private func setupOtpViews() {
        
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        otpViews.removeAll()
        
        ( 0...(length - 1)).forEach { idx in
            let otpView = OtpView()
            otpView.overlayView.isUserInteractionEnabled = enableUserInteraction
            otpView.textField.isUserInteractionEnabled = enableUserInteraction
            otpView.textField.customDelegate = self
            otpView.textField.delegate = self
            otpView.textField.tintColor = .highlightColor
            otpView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            otpView.tag = idx
            otpView.textField.tag = idx
            otpViews.append(otpView)
            self.addArrangedSubview(otpView)
        }
    }
    
    private func setupText() {
        if !text.isEmpty {
            let range = 0...(text.count - 1)
            range.forEach { idx in
                otpViews[idx].text = String(text[idx])
            }
        }
    }
    
    func setText(text: String) {
        self.endEditing(true)
        
        self.text = text
        
        if self.text.count > self.length {
            self.text = String(self.text.prefix(length))
        }
        
        otpViews.forEach { view in
            view.text = ""
        }
        
        let range = 0...(text.count - 1)
        
        range.forEach { idx in
            otpViews[idx].text = String(text[idx])
            otpViews[idx].unfocusTextField()
        }
        
        setupTextAppearance()
    }
    
    func addText(char: Character) {
        if self.text.count > self.length {
            return
        }
        
        if self.text.count < length {
            self.text = "\(self.text)\(String(char))"
            let idx = self.text.count - 1
            otpViews[idx].text = String(text[idx])
            
            setupTextAppearance()
        }
    }
    
    func clearText() {
        if !text.isEmpty {
            self.text = ""
            otpViews.forEach { view in
                view.text = ""
            }
            
            setupTextAppearance()
        }
    }
    
    func deleteLastChar() {
        if !text.isEmpty {
            if text.count == 0 {
                text = ""
            } else {
                text = String(text.prefix(text.count - 1))
            }
            
            otpViews[text.count].text = ""
            
            setupTextAppearance()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        text = ""
        otpViews.forEach { otpView in
            if let txt = otpView.text {
                text += txt
            }
        }
        
        if let text = textField.text {
            if !text.isEmpty {
                let tag = textField.tag
                if tag != length - 1 {
                    otpViews[tag + 1].focusOnTextField()
                }
            }
        }
                
        setupTextAppearance()
    }
    
    @objc private func focusOnTextField(_ sender: UITapGestureRecognizer) {
        if let view = sender.view {
            otpViews[view.tag].focusOnTextField()
        }
    }
    
    func setupTextAppearance() {
        otpViews.forEach { otpView in
            guard let otpText = otpView.text else {return}
            if otpText.isEmpty {
                otpView.layer.borderColor = UIColor.strokeColor.cgColor
                otpView.backgroundColor = .clear
            } else {
                otpView.layer.borderColor = UIColor.strokeColor.cgColor
                otpView.backgroundColor = .clear
            }
        }
        
        if self.text.count < self.length {
            self.otpViews[self.text.count].layer.borderColor = UIColor.highlightColor.cgColor
            self.otpViews[self.text.count].backgroundColor = UIColor.clear
        }
    }
    
    func setTintColor(color: UIColor) {
        otpViews.forEach { otpView in
            otpView.textField.tintColor = color
        }
    }
    
    private func setupuserInteraction() {
        arrangedSubviews.forEach({ $0.isUserInteractionEnabled = enableUserInteraction })
    }
}

// Mark: UITextFieldDelegate
extension JBOtpEntryView: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        if let text = textField.text {
            if !text.isEmpty {
                if tag != length - 1 {
                    otpViews[tag + 1].focusOnTextField()
                    return false
                }
            } else {
                if tag != 0 {
                    if let txt = otpViews[tag - 1].text {
                        if txt.isEmpty {
                            otpViews[tag - 1].focusOnTextField()
                            return false
                        } else {
                            
                            
                        }
                    }
                }
            }
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.otpViews[textField.tag].layer.borderColor = UIColor.highlightColor.cgColor
        self.otpViews[textField.tag].backgroundColor = UIColor.clear
//        if let selectedRange = textField.selectedTextRange {
//
//            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selectedRange.start)
//
//            printObject("cursorPosition", cursorPosition)
//        }
//        let oldPosition = textField.beginningOfDocument
//        let newPosition = textField.endOfDocument
//        textField.selectedTextRange = textField.textRange(from: textField.endOfDocument, to: textField.endOfDocument)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else {return}
        
        if text.isEmpty {
            self.otpViews[textField.tag].layer.borderColor = UIColor.strokeColor.cgColor
            self.otpViews[textField.tag].backgroundColor = .clear
        } else {
            self.otpViews[textField.tag].layer.borderColor = UIColor.strokeColor.cgColor
            self.otpViews[textField.tag].backgroundColor = .clear
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let fullText = "\(currentText)\(string)"
                
        if string.isEmpty {
            return true
        }
        var hasText = false
        if let text = textField.text {
            if !text.isEmpty {
                let tag = textField.tag
                if tag == length - 1 {
                    hasText = true
                }
            }
        }
        
        return fullText.isNumeric() && !hasText
    }
    
}

extension JBOtpEntryView: MyTextFieldDelegate {
    public func textField(_ textField: UITextField, didDeleteBackwardAnd wasEmpty: Bool) {
        
        if wasEmpty {
            let tag = textField.tag
            if tag != 0 {
                otpViews[tag - 1].deleteBackward()
                otpViews[tag - 1].focusOnTextField()
            }
        }
        
        text = ""
        otpViews.forEach({ text += $0.textField.text ?? "" })
    }
    
    
}

public protocol OtpEntryDelegate {
    func didEnterFullOtpCode(didEnter fullCode: String)
}
