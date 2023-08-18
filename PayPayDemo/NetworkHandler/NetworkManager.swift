//
//  NetworkManager.swift
//  CurrencyConverter
//
//  ""
//

import Foundation

protocol NetworkHandlerList {
    func getData<T: Codable>(type: T.Type,  request: URLRequest?,
                             _ handler: ((Result<T, Error>) -> Void)?)
}

enum MockData: String {
    case listMock = "MockData"
    case currencyList = "CurrencyRateList"
    case rateListWithWholeJSON = "JsonCurrencyList"
    case none
    
    func getRequest() -> URLRequest? {
        if let url = Bundle.main.path(forResource: self.rawValue , ofType: "json") {
            return URLRequest(url: URL(fileURLWithPath: url))
        }
        return nil
    }
}

class URLSessionPay {
    
    let isMock: Bool
    init(_ isMock: Bool = false) {
        self.isMock = isMock
    }
}


class NetworkManager: NetworkHandlerList {
    
    private let sessionHandler: URLSessionPay
    let responseHanlder = ResponseHandler()
    
    init(_ sessionHandler: URLSessionPay = URLSessionPay()) {
        self.sessionHandler = sessionHandler
    }
    
    func getData<T: Codable>(type: T.Type,  request: URLRequest?,
                             _ handler: ((Result<T, Error>) -> Void)?) {
        
        if sessionHandler.isMock {
            guard let path = request?.url else  {
                handler?(.failure(RequestErrorHandler.noFileExist))
                return
            }
            do {
                let data = try Data(contentsOf: path, options: .mappedIfSafe)
                self.responseHanlder.handleResponse(T.self, data: data, handler: handler)
            } catch let error {
                handler?(.failure(RequestErrorHandler.error(error.localizedDescription)))
            }
        } else {
            guard let request = request else {return}
            URLSession.shared.dataTask(with: request) { data , response , error in
                if let error = error {
                    handler?(.failure(RequestErrorHandler.error(error.localizedDescription)))
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299) ~= response.statusCode else {
                    handler?(.failure(RequestErrorHandler.error("Status code")))
                    return
                }
                self.responseHanlder.handleResponse(T.self, data: data, handler: handler)
            }
            .resume()
        }
        
    }
}


class ResponseHandler {
    
    func handleResponse<T: Codable>(_ type: T.Type,
                                    data: Data?,
                                    handler: ((Result<T, Error>) -> Void)?) {
        guard let data = data else {
            handler?(.failure(RequestErrorHandler.noData))
            return
        }
        
        do {
            let res = try JSONDecoder().decode(type.self, from: data)
            handler?(.success(res))
        }catch let error {
            print(error.localizedDescription)
            handler?(.failure(RequestErrorHandler.noData))
        }
    }
}


