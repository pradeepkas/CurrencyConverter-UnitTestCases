//
//  HomeViewController.swift
//  CurrencyConverter
//
//  ""
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HomeViewModel()

    //MARK: view controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        stateMonitor()
        viewModel.fetchData()
    }
    
    // MARK: setup views
    private func setupViews() {
        borderView.setBorder()
        selectButton.setBorder()
        tableView.dm_registerClassWithDefaultIdentifierForNib(cellClass: HomeViewCell.self)
        amountTextField.addTarget(self, action: #selector(textChangedForNew(_:)), for: .editingChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func stateMonitor() {
        viewModel.stateMonitor = { [weak self] state in
            guard let self = self else {return}
            if state.isLoading() {
                HUDIndicator.show(self.view)
            } else {
                HUDIndicator.dismiss()
            }
            switch state {
            case .data:
                self.tableView.reloadData()
            case .error(let erorr):
                self.tableView.reloadData()
                self.showError(erorr)
            default:
                break
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateResult() {
        guard let text = self.amountTextField.text else {return}
        self.viewModel.udpateDataAfterTextFieldUpdate(text)
    }
    
    // MARK: button actions
    @IBAction func selectCurrencyTapped(_ sender: UIButton) {
        let selector = CurrencySelectorVC.instantiateFromStoryboard()
        selector.selectedCurrency = { [weak self] selected in
            guard let self = self else {return}
            self.selectButton.setTitle(selected.short, for: .normal)
            self.viewModel.updateSelectedCurrency(selected)
            self.updateResult()
        }
        let viewModel = SelectorViewModel(Currency.getList(viewModel.currencyList))
        selector.viewModel = viewModel
        self.navigationController?.present(selector, animated: true)
    }

}

extension HomeViewController {
    @objc func textChangedForNew(_ textField: UITextField) {
        updateResult()
    }
}

extension HomeViewController: UITableViewDelegate,
                              UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.homeList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let homeCell: HomeViewCell = tableView.dm_dequeueReusableCellWithDefaultIdentifier()
        homeCell.setData(viewModel.homeList[indexPath.item])
        return homeCell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
