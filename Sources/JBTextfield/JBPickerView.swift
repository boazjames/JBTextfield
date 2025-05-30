//
//  File.swift
//  
//
//  Created by Boaz James on 21/07/2023.
//

import UIKit

@IBDesignable
public class BasePickerView: UIView {
    @IBInspectable public var labelText = ""
    @IBInspectable public var value = ""
    @IBInspectable public var text = ""
    public var selected = -1
    
    @IBInspectable public var placeholderColor: UIColor = UIColor.placeholderColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var textColor: UIColor = UIColor.labelColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var labelColor: UIColor = UIColor.labelColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var strokeColor: UIColor = UIColor.strokeColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var errorColor: UIColor = UIColor.errorColor {
        didSet {
            setupColors()
        }
    }
    
    @IBInspectable public var labelFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            placeHolderLabel.font = labelFont
        }
    }
    
    @IBInspectable public var textFont: UIFont = UIFont.systemFont(ofSize: 16) {
        didSet {
            label.font = textFont
        }
    }
    
    @IBInspectable public var errorLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            lblError.font = errorLabelFont
        }
    }
    
    @IBInspectable public var boxBackgroundColor: UIColor = UIColor.textFieldBackgroundColor {
        didSet {
            mainContainerView.backgroundColor = boxBackgroundColor
        }
    }
    
    @IBInspectable public var iconImage: UIImage? {
        didSet {
            pickerIcon.image = iconImage?.withRenderingMode(.alwaysTemplate)
            pickerIcon.isHidden = iconImage == nil
            label.leftInset = iconImage == nil ? 10 : 40
            placeHolderLabelLeadingConstraint.constant = iconImage == nil ? 10 : 40
        }
    }
    
    var placeHolderLabelLeadingConstraint: NSLayoutConstraint!
    
    var labelHeightConstraint: NSLayoutConstraint!
    var labelTopConstraint: NSLayoutConstraint!
    
    public var mainContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.jbBorderWidth = 1
        view.jbViewCornerRadius = 5
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var placeHolderLabel: PaddingLabel = {
        let view = PaddingLabel()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .labelColor
        view.textAlignment = .left
        view.numberOfLines = 0
        view.leftInset = 0
        view.rightInset = 0
        view.topInset = 0
        view.bottomInset = 0
        view.labelCornerRadius = 0
        return view
    }()
    
    var label: PaddingLabel = {
        let view = PaddingLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .placeholderColor
        view.textAlignment = .left
        view.labelCornerRadius = 0
        view.labelBorderColor = .clear
        view.jbBorderColor = .clear
        view.jbBorderWidth = 0
        view.leftInset = 10
        view.topInset = 0
        view.bottomInset = 0
        view.rightInset = 40
        view.numberOfLines = 0
        
        return view
    }()
    
    var icon: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "chevron_down", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .labelColor
        return imgView
    }()
    
    var pickerIcon: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .labelColor
        view.applyAspectRatio(aspectRation: 1)
        return view
    }()
    
    var lblError: PaddingLabel = {
        let view = PaddingLabel()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 0
        view.leftInset = 0
        view.rightInset = 0
        view.topInset = 0
        view.bottomInset = 0
        view.labelCornerRadius = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    public func setPlaceholder(_ placeholder: String) {
        self.labelText = placeholder
    }
    
    public func setText(_ text: String, value: String) {
        self.text = text
        self.value = value
    }
    
    func setupViews() {
        setupColors()
        
        label.font = textFont
        placeHolderLabel.font = labelFont
        lblError.font = errorLabelFont
        mainContainerView.backgroundColor = boxBackgroundColor
    }
    
    public func showError(_ message: String) {
        lblError.text = message
        
        mainContainerView.jbBorderColor = errorColor
        placeHolderLabel.textColor = errorColor
    }
    
    public func hideError() {
        lblError.text = nil
        mainContainerView.jbBorderColor = strokeColor
        placeHolderLabel.textColor = labelColor
    }
    
    func setupColors() {
        let errorMessage = lblError.text ?? ""
        
        if errorMessage.isEmpty {
            mainContainerView.jbBorderColor = strokeColor
            icon.tintColor = labelColor
            placeHolderLabel.textColor = labelColor
        } else {
            mainContainerView.jbBorderColor = errorColor
            icon.tintColor = errorColor
            placeHolderLabel.textColor = errorColor
        }
        
        label.textColor = text.isEmpty ? placeholderColor : textColor
        lblError.textColor = errorColor
    }
}

@IBDesignable
public class JBPickerView: BasePickerView {
    public var items = [JBPickerItem]()
    private var selectedItems = [JBPickerItem]()
    public var actionButtonClosure:  ((_ index: Int, _ item: JBPickerItem) -> Void)?
    public var multiActionButtonClosure:  ((_ indices: [Int], _ items: [JBPickerItem]) -> Void)?
    public var allowMultipleSelection = false
    public var maxSelection = 0
    
    override func setupViews() {
        super.setupViews()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(placeHolderLabel)
        containerView.addSubview(label)
        containerView.addSubview(pickerIcon)
        containerView.addSubview(icon)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: mainContainerView.topAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 0),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        placeHolderLabelLeadingConstraint = placeHolderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            placeHolderLabelLeadingConstraint,
            placeHolderLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        
        pickerIcon.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            pickerIcon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            pickerIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            pickerIcon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        labelHeightConstraint = placeHolderLabel.heightAnchor.constraint(equalToConstant: 0)
        labelTopConstraint = label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        label.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            labelTopConstraint,
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            labelHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),
            icon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        label.leftInset = 10
        
        mainContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showActionPicker)))
    }
    
    override public func setPlaceholder(_ placeholder: String) {
        self.labelText = placeholder
        placeHolderLabel.text = placeholder
        label.text = placeholder
    }
    
    override public func setText(_ text: String, value: String) {
        self.value = value
        self.text = text
        if text.isEmpty {
            label.text = self.labelText
            label.textColor = placeholderColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            label.text = text
            label.textColor = labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
        
        hideError()
    }
    
    private func showLabel() {
        labelTopConstraint.constant = 25
        self.layoutIfNeeded()
        let originY = label.frame.origin.y
        let distance: CGFloat = 20
        placeHolderLabel.frame.origin.y = originY + distance
        self.bringSubviewToFront(placeHolderLabel)
        
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.deactivate()
            self.placeHolderLabel.frame.origin.y = originY
            self.layoutIfNeeded()
        }
    }
    
    private func hideLabel() {
        labelTopConstraint.constant = 15
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.activate()
            self.layoutIfNeeded()
        }
    }
    
    @objc private func showActionPicker() {
        if allowMultipleSelection {
            showMultiActionPicker()
            return
        }
        
        guard let vc = findViewController() else { return }
        vc.view.endEditing(true)
        if !items.isEmpty {
            let alertVC = UIAlertController(title: labelText, message: nil, preferredStyle: .actionSheet)
            for (index, item) in items.enumerated() {
                let alertAction = UIAlertAction(title: item.title, style: .default) { (alertAction: UIAlertAction!) in
                    self.setText(item.title, value: item.value)
                    self.actionButtonClosure?(index, item)
                }
                alertVC.addAction(alertAction)
            }
            
            let cancelAction = UIAlertAction(title: "dismiss".localized, style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            
            alertVC.addAction(cancelAction)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                alertVC.popoverPresentationController?.sourceView = self
                alertVC.popoverPresentationController?.sourceRect = CGRect(x: self.bounds.size.width / 6.0, y: self.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            }
            vc.present(alertVC, animated: true)
        }
    }
    
    @objc private func showMultiActionPicker() {
        guard let parentVc = findViewController() else { return }
        parentVc.view.endEditing(true)
        if !items.isEmpty {
            let vc = MultipleSelectionVC()
            vc.completionHandler = { (indices, items) in
                self.selectedItems = items
                self.setupMultiSelectText()
                self.multiActionButtonClosure?(indices, items)
            }
            vc.items = items
            vc.pickerTitle = labelText
            vc.selectedItems = selectedItems
            vc.maxSelection = maxSelection
            
            let navVc = UINavigationController(rootViewController: vc)
            navVc.modalPresentationStyle = .fullScreen
            navVc.modalTransitionStyle = .coverVertical
            parentVc.present(navVc, animated: true)
        }
    }
    
    private func setupMultiSelectText() {
        let text = selectedItems.map({ "✦ \($0.title)" }).joined(separator: "\n")
        setText(text, value: "")
    }
    
    public func setSelectedItems(_ items: [JBPickerItem]) {
        self.selectedItems = items
        self.setupMultiSelectText()
    }
}

@IBDesignable
public class JBPlainPickerView: BasePickerView {
    public var items = [JBPickerItem]()
    private var selectedItems = [JBPickerItem]()
    public var actionButtonClosure:  ((_ index: Int, _ item: JBPickerItem) -> Void)?
    public var multiActionButtonClosure:  ((_ indices: [Int], _ items: [JBPickerItem]) -> Void)?
    public var allowMultipleSelection = false
    public var maxSelection = 0
    
    public var minWidth: CGFloat = 100 {
        didSet {
            labelMinWidthConstraint.constant = minWidth
        }
    }
    
    public var textAlignment: NSTextAlignment = .right {
        didSet {
            label.textAlignment = textAlignment
        }
    }
    
    private var labelMinWidthConstraint: NSLayoutConstraint!
    
    override func setupViews() {
        super.setupViews()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        label.textAlignment = textAlignment
        
        self.addSubview(label)
        addSubview(icon)
        
        label.pinToView(parentView: self, trailing: false)
        labelMinWidthConstraint = label.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 40),
            labelMinWidthConstraint,
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),
            icon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        label.leftInset = 0
        label.rightInset = 0
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showActionPicker)))
    }
    
    override public func setPlaceholder(_ placeholder: String) {
        self.labelText = placeholder
        label.text = placeholder
    }
    
    override public func setText(_ text: String, value: String) {
        self.value = value
        self.text = text
        if text.isEmpty {
            label.text = self.labelText
            label.textColor = placeholderColor
        } else {
            label.text = text
            label.textColor = labelColor
        }
        
        hideError()
    }
    
    @objc private func showActionPicker() {
        if allowMultipleSelection {
            showMultiActionPicker()
            return
        }
        
        guard let vc = findViewController() else { return }
        vc.view.endEditing(true)
        if !items.isEmpty {
            let alertVC = UIAlertController(title: labelText, message: nil, preferredStyle: .actionSheet)
            for (index, item) in items.enumerated() {
                let alertAction = UIAlertAction(title: item.title, style: .default) { (alertAction: UIAlertAction!) in
                    self.setText(item.title, value: item.value)
                    self.actionButtonClosure?(index, item)
                }
                alertVC.addAction(alertAction)
            }
            
            let cancelAction = UIAlertAction(title: "dismiss".localized, style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            
            alertVC.addAction(cancelAction)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                alertVC.popoverPresentationController?.sourceView = self
                alertVC.popoverPresentationController?.sourceRect = CGRect(x: self.bounds.size.width / 6.0, y: self.bounds.size.height / 2.0, width: 1.0, height: 1.0)
            }
            vc.present(alertVC, animated: true)
        }
    }
    
    @objc private func showMultiActionPicker() {
        guard let parentVc = findViewController() else { return }
        parentVc.view.endEditing(true)
        if !items.isEmpty {
            let vc = MultipleSelectionVC()
            vc.completionHandler = { (indices, items) in
                self.selectedItems = items
                self.setupMultiSelectText()
                self.multiActionButtonClosure?(indices, items)
            }
            vc.items = items
            vc.pickerTitle = labelText
            vc.selectedItems = selectedItems
            vc.maxSelection = maxSelection
            
            let navVc = UINavigationController(rootViewController: vc)
            navVc.modalPresentationStyle = .fullScreen
            navVc.modalTransitionStyle = .coverVertical
            parentVc.present(navVc, animated: true)
        }
    }
    
    private func setupMultiSelectText() {
        let text = selectedItems.map({ "✦ \($0.title)" }).joined(separator: "\n")
        setText(text, value: "")
    }
    
    public func setSelectedItems(_ items: [JBPickerItem]) {
        self.selectedItems = items
        self.setupMultiSelectText()
    }
}

@IBDesignable
public class JBDatePickerView: BasePickerView {
    
    public var date: Date?
    public var maxDate: Date?
    public var minDate: Date?
    public var datePickerMode: UIDatePicker.Mode = .date
    public var dateDispalyFormat: String = "dd MMM yyyy"
    public var dateValueFormat: String = "yyyy-MM-dd"
    public var delegate: DateTimePickerDelegate?
    
    override func setupViews() {
        super.setupViews()
                
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(pickerIcon)
        containerView.addSubview(placeHolderLabel)
        containerView.addSubview(label)
        containerView.addSubview(icon)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        mainContainerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        containerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor).activate()
        
        placeHolderLabelLeadingConstraint = placeHolderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10)
        labelHeightConstraint = placeHolderLabel.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            placeHolderLabelLeadingConstraint,
            placeHolderLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            labelHeightConstraint
        ])
        
        pickerIcon.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            pickerIcon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            pickerIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            pickerIcon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        pickerIcon.applyAspectRatio(aspectRation: 1)
        NSLayoutConstraint.activate([
            pickerIcon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            pickerIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            pickerIcon.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        label.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 40),
            label.topAnchor.constraint(equalTo: placeHolderLabel.centerYAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),
            icon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        iconImage = UIImage(named: "calendar", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        
//        label.leftInset = 37
        
        mainContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicker)))
    }
    
    override public func setPlaceholder(_ placeholder: String) {
        self.labelText = placeholder
        placeHolderLabel.text = placeholder
        label.text = placeholder
    }
    
    override public func setText(_ text: String, value: String) {
        self.value = value
        self.text = text
        if text.isEmpty {
            label.text = labelText
            label.textColor = placeholderColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            label.text = text
            label.textColor = labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
        
        hideError()
    }
    
    private func showLabel() {
        self.layoutIfNeeded()
        let originY = label.frame.origin.y
        let distance: CGFloat = 20
        placeHolderLabel.frame.origin.y = originY + distance
        self.bringSubviewToFront(placeHolderLabel)
        
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.deactivate()
            self.placeHolderLabel.frame.origin.y = originY
            self.layoutIfNeeded()
        }
    }
    
    private func hideLabel() {
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.activate()
            self.layoutIfNeeded()
        }
    }
    
    @objc private func showPicker() {
        guard let parentVC = findViewController() else { return }
        parentVC.view.endEditing(true)
        
        let vc = DateTimePickerVC()
        vc.pickerTitle = labelText
        vc.selected = date
        vc.sourceView = self
        vc.minDate = minDate
        vc.maxDate = maxDate
        vc.datePickerMode = datePickerMode
        vc.dateDispalyFormat = dateDispalyFormat
        vc.dateValueFormat = dateValueFormat
        vc.delegate = delegate
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        parentVC.present(vc, animated: true)
    }
    
    public func setDate(date: Date?) {
        self.date = date
        self.setText(date?.formatDate(formatString: dateDispalyFormat) ?? "", value: date?.formatDate(formatString: dateValueFormat) ?? "")
    }
    
    public static func showDatePicker(on viewController: UIViewController, title: String = "", selectedDate: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil, datePickerMode: UIDatePicker.Mode = .date, delegate: DateTimePickerDelegate? = nil) {
        viewController.view.endEditing(true)
        
        let vc = DateTimePickerVC()
        vc.pickerTitle = title
        vc.selected = selectedDate
        vc.minDate = minDate
        vc.maxDate = maxDate
        vc.datePickerMode = datePickerMode
        vc.dateDispalyFormat = "dd MMM yyyy"
        vc.dateValueFormat = "yyyy-MM-dd"
        vc.delegate = delegate
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        viewController.present(vc, animated: true)
    }
}

@IBDesignable
public class JBPlainDatePickerView: BasePickerView {
    
    public var date: Date?
    public var maxDate: Date?
    public var minDate: Date?
    public var datePickerMode: UIDatePicker.Mode = .date
    public var dateDispalyFormat: String = "dd MMM yyyy"
    public var dateValueFormat: String = "yyyy-MM-dd"
    public var delegate: DateTimePickerDelegate?
    
    public var minWidth: CGFloat = 100 {
        didSet {
            labelMinWidthConstraint.constant = minWidth
        }
    }
    
    public var textAlignment: NSTextAlignment = .right {
        didSet {
            label.textAlignment = textAlignment
        }
    }
    
    private var labelMinWidthConstraint: NSLayoutConstraint!
    
    override func setupViews() {
        super.setupViews()
        
        pickerIcon.image = UIImage(named: "calendar", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        label.textAlignment = textAlignment
        
        self.addSubview(label)
        addSubview(icon)
        
        label.pinToView(parentView: self, trailing: false)
        labelMinWidthConstraint = label.widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 40),
            labelMinWidthConstraint,
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: icon.leadingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),
            icon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        label.leftInset = 0
        label.rightInset = 0
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicker)))
    }
    
    override public func setPlaceholder(_ placeholder: String) {
        self.labelText = placeholder
        label.text = placeholder
    }
    
    override public func setText(_ text: String, value: String) {
        self.value = value
        self.text = text
        if text.isEmpty {
            label.text = labelText
            label.textColor = placeholderColor
        } else {
            label.text = text
            label.textColor = labelColor
        }
        
        hideError()
    }
    
    @objc private func showPicker() {
        guard let parentVC = findViewController() else { return }
        parentVC.view.endEditing(true)
        
        let vc = DateTimePickerVC()
        vc.pickerTitle = labelText
        vc.selected = date
        vc.sourceView = self
        vc.minDate = minDate
        vc.maxDate = maxDate
        vc.datePickerMode = datePickerMode
        vc.dateDispalyFormat = dateDispalyFormat
        vc.dateValueFormat = dateValueFormat
        vc.delegate = delegate
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        parentVC.present(vc, animated: true)
    }
    
    public func setDate(date: Date?) {
        self.date = date
        self.setText(date?.formatDate(formatString: dateDispalyFormat) ?? "", value: date?.formatDate(formatString: dateValueFormat) ?? "")
    }
    
    public static func showDatePicker(on viewController: UIViewController, title: String = "", selectedDate: Date? = nil, minDate: Date? = nil, maxDate: Date? = nil, datePickerMode: UIDatePicker.Mode = .date, delegate: DateTimePickerDelegate? = nil) {
        viewController.view.endEditing(true)
        
        let vc = DateTimePickerVC()
        vc.pickerTitle = title
        vc.selected = selectedDate
        vc.minDate = minDate
        vc.maxDate = maxDate
        vc.datePickerMode = datePickerMode
        vc.dateDispalyFormat = "dd MMM yyyy"
        vc.dateValueFormat = "yyyy-MM-dd"
        vc.delegate = delegate
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        viewController.present(vc, animated: true)
    }
}

@IBDesignable
public class JBDatePickerViewV2: BasePickerView {
    
    public var date: Date?
    public var maxDate: Date?
    public var minDate: Date?
    public var datePickerMode: UIDatePicker.Mode = .date
    public var dateDispalyFormat: String = "dd MMM yyyy"
    public var dateValueFormat: String = "yyyy-MM-dd"
    public var delegate: DateTimePickerDelegate?
    
    override func setupViews() {
        super.setupViews()
                
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        self.addSubview(mainContainerView)
        mainContainerView.addSubview(containerView)
        containerView.addSubview(placeHolderLabel)
        containerView.addSubview(label)
        containerView.addSubview(icon)
        self.addSubview(lblError)
        
        mainContainerView.pinToView(parentView: self, bottom: false)
        mainContainerView.heightAnchor.constraint(equalToConstant: 60).activate()
        
        containerView.pinToView(parentView: mainContainerView, top: false, bottom: false)
        containerView.centerYAnchor.constraint(equalTo: mainContainerView.centerYAnchor).activate()
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            placeHolderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            placeHolderLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10)
        ])
        labelHeightConstraint = placeHolderLabel.heightAnchor.constraint(equalToConstant: 0)
        labelHeightConstraint.activate()
        
        label.pinToView(parentView: containerView, constant: 0, top: false, bottom: false)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 40),
            label.topAnchor.constraint(equalTo: placeHolderLabel.centerYAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 18),
            icon.heightAnchor.constraint(equalToConstant: 18),
            icon.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15)
        ])
        
        lblError.pinToView(parentView: self, top: false)
        lblError.topAnchor.constraint(equalTo: mainContainerView.bottomAnchor, constant: 4).activate()
        
        label.leftInset = 10
        
        mainContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPicker)))
    }
    
    override public func setPlaceholder(_ placeholder: String) {
        self.labelText = placeholder
        placeHolderLabel.text = placeholder
        label.text = placeholder
    }
    
    override public func setText(_ text: String, value: String) {
        self.value = value
        self.text = text
        if text.isEmpty {
            label.text = labelText
            label.textColor = placeholderColor
            
            if !labelHeightConstraint.isActive {
                hideLabel()
            }
        } else {
            label.text = text
            label.textColor = labelColor
            
            if labelHeightConstraint.isActive {
                showLabel()
            }
        }
        
        hideError()
    }
    
    private func showLabel() {
        self.layoutIfNeeded()
        let originY = label.frame.origin.y
        let distance: CGFloat = 20
        placeHolderLabel.frame.origin.y = originY + distance
        self.bringSubviewToFront(placeHolderLabel)
        
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.deactivate()
            self.placeHolderLabel.frame.origin.y = originY
            self.layoutIfNeeded()
        }
    }
    
    private func hideLabel() {
        UIView.animate(withDuration: 0.3) {
            self.labelHeightConstraint.activate()
            self.layoutIfNeeded()
        }
    }
    
    @objc private func showPicker() {
        guard let parentVC = findViewController() else { return }
        parentVC.view.endEditing(true)
        
        let vc = DateTimePickerVCV2()
        vc.pickerTitle = labelText
        vc.selected = date
        vc.sourceView = self
        vc.minDate = minDate
        vc.maxDate = maxDate
        vc.datePickerMode = datePickerMode
        vc.dateDispalyFormat = dateDispalyFormat
        vc.dateValueFormat = dateValueFormat
        vc.delegate = delegate
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        parentVC.present(vc, animated: true)
    }
    
    public func setDate(date: Date?) {
        self.date = date
        self.setText(date?.formatDate(formatString: dateDispalyFormat) ?? "", value: date?.formatDate(formatString: dateValueFormat) ?? "")
    }
}
