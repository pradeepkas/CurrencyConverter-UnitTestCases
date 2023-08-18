//
//  TableView.swift
//  CurrencyConverter
//
//  ""
//

import UIKit

extension UITableViewCell {
    @objc static var dm_defaultIdentifier: String { return String(describing: self) }
}

extension UITableView {
    
    func dm_registerClassWithDefaultIdentifier(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: cellClass.dm_defaultIdentifier)
    }
    
    func dm_registerClassWithDefaultIdentifierForNib(cellClass: AnyClass) {
        register(UINib(nibName: cellClass.dm_defaultIdentifier, bundle: nil), forCellReuseIdentifier: cellClass.dm_defaultIdentifier)
    }
    
    func dm_dequeueReusableCellWithDefaultIdentifier<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: T.dm_defaultIdentifier) as! T
    }
}
