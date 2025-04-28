//
//  File.swift
//  
//
//  Created by Boaz James on 21/07/2023.
//

import UIKit

class DateTimePickerVC: BaseVC {
    var items: [String] = []
    var pickerTitle: String!
    var delegate: DateTimePickerDelegate?
    var selected: Date?
    var sourceView: UIView?
    var maxDate: Date?
    var minDate: Date?
    var datePickerMode: UIDatePicker.Mode = .date
    var dateDispalyFormat: String = "dd MMM yyyy"
    var dateValueFormat: String = "yyyy-MM-dd"
    
    private var container: JBCardView = {
        let view = JBCardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.showTopShadow = true
        view.shadowOpacity = 0.1
        view.cornerRadius = 0
        view.showBottomLeftRadius = false
        view.showBottomRightRadius = false
        return view
    }()
    
    private var pickerView: UIDatePicker = {
        let view = UIDatePicker()
        view.backgroundColor = .clear
        view.minimumDate = Date()
        if #available(iOS 13.4, *) {
            view.preferredDatePickerStyle = .wheels
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var headerView: UIView = {
        let view = JBCardView()
        view.cornerRadius = 0
        view.showBottomLeftRadius = false
        view.showBottomRightRadius = false
        view.shadowOpacity = 0
        view.backgroundColor = .skyBlueLightColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var lblTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .labelColor
        lbl.numberOfLines = 1
        lbl.font = .systemFont(ofSize: 18)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.3
        return lbl
    }()
    
    private var btnCancel: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("dismiss".localized, for: .normal)
        btn.setTitleColor(.labelColor, for: .normal)
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
    
    private var btnDone: UIButton = {
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
        
        self.view.backgroundColor = .clear
        self.view.addSubview(container)
        container.addSubview(pickerView)
        container.addSubview(headerView)
        headerView.addSubview(btnDone)
//        headerView.addSubview(btnCancel)
        headerView.addSubview(lblTitle)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        headerView.pinToView(parentView: container, bottom: false)
        
        headerView.bottomAnchor.constraint(equalTo: pickerView.topAnchor).isActive = true
        
//        NSLayoutConstraint.activate([
//            btnCancel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
//            btnCancel.centerYAnchor.constraint(equalTo: lblTitle.centerYAnchor),
//            btnCancel.widthAnchor.constraint(equalToConstant: btnCancel.intrinsicContentSize.width)
//        ])
        
        NSLayoutConstraint.activate([
            lblTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            lblTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15),
            lblTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15),
            lblTitle.widthAnchor.constraint(equalTo: headerView.widthAnchor, constant: -((btnDone.intrinsicContentSize.width * 2) + 15 + 15))
        ])
        
        NSLayoutConstraint.activate([
            btnDone.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            btnDone.centerYAnchor.constraint(equalTo: lblTitle.centerYAnchor),
            btnDone.widthAnchor.constraint(equalToConstant: btnDone.intrinsicContentSize.width)
        ])
        
        pickerView.pinToView(parentView: container, top: false, bottom: false)
        
        NSLayoutConstraint.activate([
            pickerView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -safeAreaBottomInset()),
            pickerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
    }
    
    override func setupGestures() {
        btnCancel.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        btnDone.addTarget(self, action: #selector(selectionDone), for: .touchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
        self.container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dummyClick)))
    }
    
    @objc private func dismissController() {
        self.dismiss(animated: true)
    }
    
    @objc private func selectionDone() {
        if let sourceView = sourceView as? JBDatePickerView {
            sourceView.setText(self.pickerView.date.formatDate(formatString: dateDispalyFormat), value: self.pickerView.date.formatDate(formatString: dateValueFormat))
            sourceView.date = pickerView.date
            
            self.dismiss(animated: false) {
                self.delegate?.didSelect?(didSelectDate: self.pickerView.date, sourceView: sourceView)
            }
        } else if let sourceView = sourceView as? JBDatePickerViewV2 {
            sourceView.setText(self.pickerView.date.formatDate(formatString: dateDispalyFormat), value: self.pickerView.date.formatDate(formatString: dateValueFormat))
            sourceView.date = pickerView.date
            
            self.dismiss(animated: false) {
                self.delegate?.didSelectV2?(didSelectDate: self.pickerView.date, sourceView: sourceView)
            }
        } else if let sourceView = sourceView as? JBPlainDatePickerView {
            sourceView.setText(self.pickerView.date.formatDate(formatString: dateDispalyFormat), value: self.pickerView.date.formatDate(formatString: dateValueFormat))
            sourceView.date = pickerView.date
            
            self.dismiss(animated: false) {
                self.delegate?.didSelectV3?(didSelectDate: self.pickerView.date, sourceView: sourceView)
            }
        }
    }
    
}

@objc public protocol DateTimePickerDelegate {
    @objc optional func didSelect(didSelectDate date: Date, sourceView: JBDatePickerView?)
    
    @objc optional func didSelectV2(didSelectDate date: Date, sourceView: JBDatePickerViewV2?)
    
    @objc optional func didSelectV3(didSelectDate date: Date, sourceView: UIView?)
}
