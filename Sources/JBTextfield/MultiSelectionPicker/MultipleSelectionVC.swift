//
//  MultipleSelectionVC.swift
//
//
//  Created by Boaz James on 21/06/2024.
//

import UIKit

class MultipleSelectionVC: BaseVC {
    
    private let tblView: UITableView = {
        let tblView = UITableView()
        tblView.backgroundColor = .clear
        tblView.allowsSelectionDuringEditing = false
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        }
        tblView.tableFooterView = UIView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.showsVerticalScrollIndicator = false
        tblView.allowsSelection = true
        tblView.allowsMultipleSelection = true
        tblView.separatorStyle = .singleLine
        tblView.separatorInset = .zero
        tblView.contentInset = UIEdgeInsets.zero
        tblView.tableHeaderView = nil
        if #available(iOS 15.0, *) {
            tblView.sectionHeaderTopPadding = 0
        }
        tblView.allowsSelectionDuringEditing = true
        return tblView
    }()
    
    private let buttonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowRadius = 2.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        return view
    }()
    
    private let btnSubmit: MyButton =  {
        let view = MyButton()
        view.setTitle("done".localized, for: .normal)
        
        return view
    }()
    
    var completionHandler: ((_ indices: [Int], _ items: [JBPickerItem]) -> Void)?
    
    var pickerTitle = ""
    var maxSelection = 0
    var selectedItems = [JBPickerItem]()
    var items = [JBPickerItem]()
    private var filteredItems = [JBPickerItem]()
    
    private let searchController: UISearchController = {
        let vc = UISearchController()
        return vc
    }()
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    private var searchText: String? {
        return searchController.searchBar.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupData()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hideNavBarShadow()
        
        self.showNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hideNavBar()
    }
    
    override func setupViews() {
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .backgroundColor
        }
        self.view.addSubview(tblView)
        self.view.addSubview(buttonContainer)
        buttonContainer.addSubview(btnSubmit)
        
        let btnItem = UIBarButtonItem(image: UIImage(named: "close", in: .module, compatibleWith: nil)?.renderResizedImage(25)?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(dismissViewController))
        self.navigationItem.rightBarButtonItem = btnItem
    }
    
    override func setupSharedContraints() {
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tblView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            tblView.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 0),
            tblView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            tblView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            buttonContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            buttonContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            buttonContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            btnSubmit.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15),
            btnSubmit.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            btnSubmit.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 15),
            btnSubmit.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: -(15 + safeAreaBottomInset()))
        ])
    }
    
    override func setupTableView() {
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.register(MultipleSelectionCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func setupGestures() {
        btnSubmit.addTarget(self, action: #selector(validateFields), for: .touchUpInside)
    }
    
    override func validateFields() {
        let selectedRows = tblView.indexPathsForSelectedRows ?? []
        
        let selectedItems = selectedRows.map({ filteredItems[$0.row] })
        let selectedIndices = selectedItems.map({ item in items.firstIndex(where: { $0.value == item.value }) ?? 0 })
        
        if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: false)
        }
        
        completionHandler?(selectedIndices, selectedItems)
        self.dismiss(animated: true)
    }
    
    private func setupData() {
        title = String(format: "Select %@".localized, pickerTitle)
        
//        lblTitle.text = String(format: "You can select upto %d %@".localized, maxSelection, pickerTitle)
        
        filteredItems.append(contentsOf: items)
        
        tblView.reloadData()
        
        selectedItems.forEach { selecteditem in
            if let index = items.firstIndex(where: { $0.value == selecteditem.value }) {
                tblView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
            }
        }
    }
    
    // MARK: - Search
    private func setupSearch() {
        // Text changes
        searchController.searchResultsUpdater = self
        
        // Do not obsecure
        searchController.obscuresBackgroundDuringPresentation = false
        
        
        searchController.searchBar.placeholder = String(format: "Search %@".localized, pickerTitle)
        navigationItem.searchController = searchController
        
        //hide search when nav to another ViewController
        definesPresentationContext = true
        
        self.searchController.extendedLayoutIncludesOpaqueBars = true
        
        self.searchController.searchBar.backgroundColor = .clear
        self.searchController.searchBar.barTintColor = .whiteColor
        self.searchController.searchBar.tintColor = .whiteColor
        self.searchController.searchBar.searchBarStyle = .minimal
        if #available(iOS 13.0, *) {
            self.searchController.searchBar.searchTextField.textColor = .labelColor
            self.searchController.searchBar.searchTextField.backgroundColor = .systemBackground
            self.searchController.searchBar.searchTextField.tintColor = .whiteColor
        }
    }
    
    private func handleSearch() {
        let text = searchText ?? ""
        filteredItems.removeAll()
        
        if text.isEmpty {
            filteredItems.append(contentsOf: items)
        } else {
            filteredItems.append(contentsOf: items.filter({ $0.title.containsIgnoringCase(text) }))
        }
        
        tblView.reloadData()
    }
}

// MARK: UITableViewDataSource
extension MultipleSelectionVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = filteredItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MultipleSelectionCell
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        
        cell.configure(item)
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension MultipleSelectionVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let selectedRows =  tableView.indexPathsForSelectedRows
        
        if let selectedRow = tableView.indexPathsForSelectedRows?.filter({ $0 == indexPath }).first {
            tableView.deselectRow(at: selectedRow, animated: true)
            return nil
        } else if maxSelection != 0 && selectedRows?.count == maxSelection {
            return nil
        }
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 120.0
        tableView.rowHeight = UITableView.automaticDimension
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

// Mark: - UITextFieldDelegate
extension MultipleSelectionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UISearchResultsUpdating
extension MultipleSelectionVC: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        handleSearch()
    }
}
