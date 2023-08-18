//
//  UserDefault+Ex.swift
//  CurrencyConverter
//
//  ""
//

import Foundation


extension UserDefaults {

   private enum Keys {
        static let differenceMinutesJSONData = "keyPayPay1"
        static let jsonData = "keyPayPay2"
        static let currenciesData = "keyPayPay3"
        static let differenceMinutesCurrency = "keyPayPay4"
    }

    public class var differenceMinutesJSONData: Double {
        get {
            return UserDefaults.standard.double(forKey: Keys.differenceMinutesJSONData)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.differenceMinutesJSONData)
        }
    }
    
    public class var jsonData: [String: Any] {
        get {
            return UserDefaults.standard.dictionary(forKey: Keys.jsonData) ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.jsonData)
        }
    }

    public class var currenciesData: [String: Any] {
        get {
            return UserDefaults.standard.dictionary(forKey: Keys.currenciesData) ?? [:]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.currenciesData)
        }
    }
    
    public class var differenceMinutesCurrency: Double {
        get {
            return UserDefaults.standard.double(forKey: Keys.differenceMinutesCurrency)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.differenceMinutesCurrency)
        }
    }


}
