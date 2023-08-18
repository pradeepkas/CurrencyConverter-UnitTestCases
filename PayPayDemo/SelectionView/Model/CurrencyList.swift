//
//  CurrencyList.swift
//  CurrencyConverter
//

import Foundation

struct Currency {
    let short: String
    let fullFormCountry: String
    
    static func getList(_ data: [String: String]) -> [Currency] {
        var list = data.map({Currency(short: $0.key, fullFormCountry: $0.value)})
        list = list.sorted(by: {$0.short < $1.short})
        return list
    }
    
    static func saveLocally(_ data: [String: String]) {
        UserDefaults.currenciesData = data
        UserDefaults.differenceMinutesCurrency = Date().timeIntervalSince1970
    }
    
    static func getFromLocal() -> [String: String] {
        return UserDefaults.currenciesData as? [String: String] ?? [:]
    }
    
}
