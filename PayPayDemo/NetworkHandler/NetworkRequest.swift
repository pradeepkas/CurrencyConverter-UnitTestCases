//
//  NetworkRequest.swift
//  CurrencyConverter
//
//  Created by Pradeep kumar on 14/8/23.
//

import Foundation


protocol NetworkRequestHome {
    func getCurrencies(_ handler: @escaping ((Result<[String: String], Error>) -> Void))
    func getCurrenciesRates(_ handler: @escaping ((Result<LatestJSONModel, Error>) -> Void))
}


class HomeReqeusts: NetworkRequestHome {
    
    let network: NetworkHandlerList
    
    init(network: NetworkHandlerList = NetworkManager()) {
        self.network = network
    }

    func getCurrencies(_ handler: @escaping ((Result<[String : String], Error>) -> Void)) {
        //let request = PayPayRequestHandler.currencies
        let network = NetworkManager(URLSessionPay(true))
        let mockRequest = MockData.listMock.getRequest()
        network.getData(type: [String: String].self, request: mockRequest) { result in
            handler(result)
        }
    }
    
    func getCurrenciesRates(_ handler: @escaping ((Result<LatestJSONModel, Error>) -> Void)) {
        //let request = PayPayRequestHandler.latestJSON
        let network = NetworkManager(URLSessionPay(true))
        let mockRequest = MockData.rateListWithWholeJSON.getRequest()
        network.getData(type: LatestJSONModel.self, request: mockRequest) { results in
            handler(results)
        }
    }
    
}

