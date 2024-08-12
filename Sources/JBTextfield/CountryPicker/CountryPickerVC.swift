//
//  File.swift
//  
//
//  Created by Boaz James on 20/07/2023.
//

import UIKit

class CountryPickerVC: BaseVC {
    var delegate: CountryPickerDelegate?
    var textfield: BasePhoneField?
    
    var icSearch: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "search", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .labelColor
        return imgView
    }()
    
    private var tfSearch: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .labelColor
        textField.textAlignment = .left
        textField.placeholder = "Search"
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 18)
        textField.returnKeyType = .search
        return textField
    }()
    
    private var searchContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .textFieldBackgroundColor
        return view
    }()
    
    private var tableView: UITableView = {
        let tblView = UITableView()
        tblView.allowsMultipleSelection = false
        tblView.allowsSelectionDuringEditing = false
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        }
        tblView.tableFooterView = UIView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.showsVerticalScrollIndicator = false
        tblView.allowsSelection = true
        tblView.backgroundColor = .clear
        return tblView
    }()
    
    private var allCountries: [JBCountry] = []
    private var countries: [JBCountry] = []
    var customDialCodes: [String] = []
    var selectedCountryCode: String?
    private var selectedCountry: JBCountry?
    var filteredCountries: [JBCountry] = []
    var completion: ((_ country: JBCountry, _ flag: UIImage?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "select_country".localized
        
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.changeNavBarAppearance(isLightContent: false)
    }
    
    override func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(searchContainer)
        searchContainer.addSubview(icSearch)
        searchContainer.addSubview(tfSearch)
        self.view.addSubview(tableView)
        
        let backImg = UIImage(named: "close", in: .module, compatibleWith: nil)?.renderResizedImage(20)
        let backItem = UIBarButtonItem(image: backImg, style: .plain, target: self, action: #selector(navBack))
        
        navigationItem.setLeftBarButton(backItem, animated: false)
        
        searchContainer.pinToView(parentView: self.view, constant: 15, top: false, bottom: false)
        
        searchContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).activate()
        
        NSLayoutConstraint.activate([
            icSearch.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 10),
            icSearch.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
            icSearch.heightAnchor.constraint(equalToConstant: 20),
            icSearch.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            tfSearch.leadingAnchor.constraint(equalTo: icSearch.trailingAnchor, constant: 10),
            tfSearch.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: 10),
            tfSearch.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            tfSearch.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor),
            tfSearch.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        tableView.pinToView(parentView: self.view, constant: 15, top: false, bottom: false)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tfSearch.delegate = self
    }
    
    override func setupTableView() {
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CountryCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func setupGestures() {
        tfSearch.addTarget(self, action: #selector(filterData), for: .editingChanged)
    }
    
    @objc private func navBack() {
        self.dismiss(animated: true)
    }
    
    @objc private func filterData() {
        filteredCountries.removeAll()
        if let text = tfSearch.text?.trimmingCharacters(in: .whitespaces) {
            if !text.isEmpty {
                let filtered = countries.filter { item in
                    item.name.lowercased().contains(text.lowercased())
                }
                
                filteredCountries.append(contentsOf: filtered)
                
            } else {
                filteredCountries.append(contentsOf: countries)
            }
        } else {
            filteredCountries.append(contentsOf: countries)
        }
                
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension CountryPickerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.filteredCountries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryCell
        cell.selectionStyle = .default
        cell.flagImg.image = UIImage(named: item.code.lowercased(), in: .module, compatibleWith: nil)
                
        cell.lblName.text = "\(item.name) (\(item.code.uppercased()))"
        cell.lblCode.text = "+\(item.dialCode)"
        
        cell.checkIcon.image = nil
        
        cell.hideCheckMark()

        if let selected = selectedCountry {
            if item.code.lowercased() == selected.code.lowercased() {
                cell.checkIcon.image = UIImage(named: "success", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                cell.showCheckMark()
            }
        }
        return cell
    }
    
}
    

// MARK: - UITableViewDelegate
extension CountryPickerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = filteredCountries[indexPath.row]
        self.delegate?.onSelect(didSelectCountry: item)
        textfield?.setCountry(item)
        completion?(item, UIImage(named: item.code, in: .module, compatibleWith: nil))
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

protocol CountryPickerDelegate {
    func onSelect(didSelectCountry country: JBCountry)
}


extension CountryPickerVC {
    private func populateData() {
        guard let path = Bundle.module.path(forResource: "countries", ofType: "json") else { return }
        let jsonString = (try? String(contentsOfFile: path, encoding: String.Encoding.utf8)) ?? ""
        let data = Data(jsonString.utf8)
        allCountries = (try? JSONDecoder().decode([JBCountry].self, from: data)) ?? []
        countries.removeAll()
        
        if customDialCodes.isEmpty {
            countries.append(contentsOf: allCountries)
        } else {
            let filtered = allCountries.filter({ self.customDialCodes.contains($0.dialCode) })
            countries.append(contentsOf: filtered)
        }
        if countries.isEmpty {
            countries.removeAll()
            countries.append(contentsOf: allCountries)
        }
        
        filteredCountries.append(contentsOf: countries)
        
        if let  selectedCountryCode = selectedCountryCode?.trimmingCharacters(in: .whitespacesAndNewlines), !selectedCountryCode.isEmpty {
            selectedCountry = countries.filter({ $0.dialCode == selectedCountryCode }).first
        }
        
        tableView.reloadData()
    }
}

// MARK: - UITextFieldDelegate
extension CountryPickerVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        filterData()
        return true
    }
}
