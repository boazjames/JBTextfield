//
//  DateTimePickerVCV2.swift
//  JBTextfield
//
//  Created by Boaz James on 29/01/2025.
//

import UIKit

class DateTimePickerVCV2: BaseVC {
    var items: [String] = []
    var pickerTitle: String!
    var delegate: DateTimePickerDelegate?
    var selected: Date?
    var sourceView: JBDatePickerViewV2?
    var maxDate: Date?
    var minDate: Date?
    var datePickerMode: UIDatePicker.Mode = .date
    var dateDispalyFormat: String = "dd MMM yyyy"
    var dateValueFormat: String = "yyyy-MM-dd"
    
    private let containerView: JBCardView = {
        let view = JBCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.showTopShadow = true
        view.shadowOpacity = 0.1
        view.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let pickerView: UIDatePicker = {
        let view = UIDatePicker()
        view.backgroundColor = .clear
        view.minimumDate = Date()
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let lblTitle: PaddingLabel = {
        let lbl = PaddingLabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .labelColor
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.3
        lbl.topInset = 13
        lbl.bottomInset = 13
        lbl.leftInset = 15
        lbl.rightInset = 15
        return lbl
    }()
    
    private let titleDividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            view.backgroundColor = .separator
        } else {
            view.backgroundColor = .lightGray
        }
        return view
    }()
    
    private let pickerDividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            view.backgroundColor = .separator
        } else {
            view.backgroundColor = .lightGray
        }
        return view
    }()
    
    private let btnDividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            view.backgroundColor = .separator
        } else {
            view.backgroundColor = .lightGray
        }
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fillEqually
        view.alignment = .fill
        view.axis = .horizontal
        view.spacing = 0
        view.backgroundColor = .clear
        
        return view
    }()
    
    private let btnDismiss: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("dismiss".localized, for: .normal)
        btn.setTitleColor(.secondaryLabelColor, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17)
        btn.backgroundColor = .clear
        btn.isUserInteractionEnabled = true
        
        if #available(iOS 15.0, *) {
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .clear
            
            var config = UIButton.Configuration.plain()
            config.background = backgroundConfig
            btn.configuration = config
        }
        
        return btn
    }()
    
    private let btnDone: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("done".localized, for: .normal)
        btn.setTitleColor(.highlightColor, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17)
        btn.backgroundColor = .clear
        btn.isUserInteractionEnabled = true
        
        if #available(iOS 15.0, *) {
            var backgroundConfig = UIBackgroundConfiguration.clear()
            backgroundConfig.backgroundColor = .clear
            
            var config = UIButton.Configuration.plain()
            config.background = backgroundConfig
            btn.configuration = config
        }
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let date = selected {
            pickerView.date = date
        }
        
        pickerView.minimumDate = minDate
        pickerView.maximumDate = maxDate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 13.0, *) {
            super.changeStatusBarStyle(.darkContent)
        }
    }
    
    override func setupLabels() {
        lblTitle.text = pickerTitle
    }
    
    override func setupViews() {
        pickerView.datePickerMode = datePickerMode
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        containerView.addSubview(lblTitle)
        containerView.addSubview(titleDividerView)
        containerView.addSubview(pickerView)
        containerView.addSubview(pickerDividerView)
        containerView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(btnDismiss)
        buttonStackView.addArrangedSubview(btnDone)
        containerView.addSubview(btnDividerView)
        
    }
    
    override func setupSharedContraints() {
        super.setupSharedContraints()
        
        // containerView
        NSLayoutConstraint.activate( [
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        // lblTitle
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            lblTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        // titleDividerView
        NSLayoutConstraint.activate([
            titleDividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleDividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleDividerView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor),
            titleDividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // pickerView
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: titleDividerView.bottomAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        // pickerDividerView
        NSLayoutConstraint.activate([
            pickerDividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            pickerDividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            pickerDividerView.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 0),
            pickerDividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // btnDividerView
        NSLayoutConstraint.activate([
            btnDividerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            btnDividerView.topAnchor.constraint(equalTo: buttonStackView.topAnchor),
            btnDividerView.bottomAnchor.constraint(equalTo: buttonStackView.bottomAnchor),
            btnDividerView.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        // buttonStackView
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            buttonStackView.topAnchor.constraint(equalTo: pickerDividerView.bottomAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        btnDone.heightAnchor.constraint(equalToConstant: 50).activate()
        btnDismiss.heightAnchor.constraint(equalToConstant: 50).activate()
    }
    
    override func setupContraints() {
        super.setupContraints()
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        constraints.forEach({ $0.deactivate() })
        constraints.removeAll()
        
        if traitCollection.horizontalSizeClass == .compact {
            // containerView
            constraints.append(contentsOf: [
                containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
                containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            ])
        } else {
            // containerView
            constraints.append(contentsOf: [
                containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                containerView.widthAnchor.constraint(equalToConstant: 600),
            ])
        }
        
        constraints.forEach({ $0.activate() })
    }
    
    override func setupGestures() {
        btnDismiss.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        btnDone.addTarget(self, action: #selector(selectionDone), for: .touchUpInside)
//        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
//        self.containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dummyClick)))
    }
    
    @objc private func dismissController() {
        self.dismiss(animated: true)
    }
    
    @objc private func selectionDone() {
        sourceView?.setText(self.pickerView.date.formatDate(formatString: dateDispalyFormat), value: self.pickerView.date.formatDate(formatString: dateValueFormat))
        sourceView?.date = pickerView.date
        self.dismiss(animated: false) {
            self.delegate?.didSelect(didSelectDate: self.pickerView.date, sourceView: self.sourceView)
        }
    }
    
}
