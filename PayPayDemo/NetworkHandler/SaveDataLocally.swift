//
//  SaveDataLocally.swift
//  CurrencyConverter
//
//  Created by Pradeep kumar on 14/8/23.
//

import Foundation

protocol LocalData {
    func saveCurrenciesRates(_ data: [String: Double])
    func saveCurrencies(_ data: [String: String])
}


class LocalHandler: LocalData {
    
    func saveCurrenciesRates(_ data: [String : Double]) {
        CurrencyRates.saveLocally(data)
    }
    
    func saveCurrencies(_ data: [String : String]) {
        Currency.saveLocally(data)
    }
    
}
