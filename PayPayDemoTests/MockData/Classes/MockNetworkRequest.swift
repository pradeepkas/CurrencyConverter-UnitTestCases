//
//  MockNetworkRequest.swift
//  CurrencyConverterTests
//
//  Created by Pradeep kumar on 14/8/23.
//

import Foundation
@testable import PayPayDemo

// network call mocks with network requests
class MockNetworkRequest: NetworkRequestHome {
    func getCurrencies(_ handler: @escaping ((Result<[String : String], Error>) -> Void)) {
        let network = NetworkManager(URLSessionPay(true))
        let bundle = Bundle(for: type(of: self))
        let req = MockDataTest.currencyListMock.getPath(bundle)
        network.getData(type: [String: String].self, request: req, handler)
    }
    
    func getCurrenciesRates(_ handler: @escaping (Result<PayPayDemo.LatestJSONModel, Error>) -> Void) {
        let network = NetworkManager(URLSessionPay(true))
        let bundle = Bundle(for: type(of: self))
        let req = MockDataTest.currencyRatesMock.getPath(bundle)
        network.getData(type: PayPayDemo.LatestJSONModel.self, request: req) { result in
            handler(result)
        }
    }
}
