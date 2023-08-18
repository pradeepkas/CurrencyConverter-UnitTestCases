//
//  LocalSaverMock.swift
//  CurrencyConverterTests
//
//  Created by Pradeep kumar on 14/8/23.
//

import Foundation
@testable import PayPayDemo

// local saver
class LocalSaverMock: LocalData {
    func saveCurrenciesRates(_ data: [String : Double]) {   }
    func saveCurrencies(_ data: [String : String]) {     }
}
