//
//  UIView.swift
//  CurrencyConverter
//
//  ""
//

import UIKit


extension UIView {
    
    func setBorder(_ borderWidth: CGFloat = 6) {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 6
    }
    
}
