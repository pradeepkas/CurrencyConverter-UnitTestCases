//
//  CurrencySelectorVC.swift
//  CurrencyConverter
//
//  ""
//

import UIKit

final class CurrencySelectorVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel: SelectorViewModel?
    var selectedCurrency: ((Currency) -> Void)?

    //MARK: view controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stateMonitor()
        setupViews()
    }
    
    
    // MARK: setup views
    private func setupViews() {
        borderView.setBorder()
        tableView.dm_registerClassWithDefaultIdentifierForNib(cellClass: CurrencyCell.self)
        searchTextField.addTarget(self, action: #selector(textChangedForNew(_:)), for: .editingChanged)
    }
    
    private func stateMonitor() {
        viewModel?.stateMonitor = { [weak self] state in
            guard let self = self else {return}
            switch state {
            case .data:
                self.tableView.reloadData()
            default:
                break
            }
        }
    }
}

extension CurrencySelectorVC: UITextFieldDelegate {
    
    @objc
    func textChangedForNew(_ textField: UITextField) {
        viewModel?.filterData(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension CurrencySelectorVC: UITableViewDelegate,
                              UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel?.filterData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selectorCell: CurrencyCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()
        
        let list = viewModel?.filterData[indexPath.item]
        selectorCell.configureCell(list)
        return selectorCell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let selected = viewModel?.filterData[indexPath.item] {
            selectedCurrency?(selected)
            self.dismiss(animated: true)
        }
    }
}
