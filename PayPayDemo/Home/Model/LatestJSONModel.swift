//
//  LatestJSONModel.swift
//  CurrencyConverter
//
//  ""
//

import Foundation

struct LatestJSONModel: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Double
    let base: String
    let rates: [String: Double]
}

struct CurrencyRates {
    let currenecyName: String
    let currencyRate: Double
    
    static func getList(_ data: [String: Double]) -> [CurrencyRates] {
        return data.map({CurrencyRates(currenecyName: $0.key, currencyRate: $0.value)})
    }
    
    static func saveLocally(_ data: [String: Double]) {
        UserDefaults.jsonData = data
        UserDefaults.differenceMinutesJSONData = Date().timeIntervalSince1970
    }
    
    static func getFromLocal() -> [CurrencyRates] {
        let values = UserDefaults.jsonData
        return values.map({CurrencyRates(currenecyName: $0.key, currencyRate: $0.value as? Double ?? 0.0 )})
    }

}
