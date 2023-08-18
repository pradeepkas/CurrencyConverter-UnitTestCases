//
//  MockDataTest.swift
//  CurrencyConverterTests
//
//  Created by Pradeep kumar on 14/8/23.
//

import Foundation

// mocking for urls for local files
enum MockDataTest: String {
    case currencyRatesMock = "CurrencyRatesMock"
    case currencyListMock = "CurrencyListMock"
    
    func getPath(_ bundle: Bundle) -> URLRequest? {
        guard let fileUrl = bundle.url(forResource: self.rawValue, withExtension: "json") else {return nil}
        let req = URLRequest(url: fileUrl)
        return req
    }
}
