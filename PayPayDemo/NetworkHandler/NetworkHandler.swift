//
//  NetworkHandler.swift
//  CurrencyConverter
//
//  ""
//

import Foundation


protocol Requestable {
    var basePath: String {get}
    var method: String {get}
    var httpType: String {get}
    var queryItems: [String: String] {get}
}


extension Requestable {
    
    var basePath: String {
        return "https://openexchangerates.org/api/"
    }
    
    func asRequest() ->  URLRequest? {
        var urlComponents = URLComponents(string: basePath + method)
        urlComponents?.queryItems = queryItemConversion
        guard let url = urlComponents?.url else {return nil}
        let request = URLRequest(url: url)
        return request
    }
    
    func asURL() -> URL? {
        var urlComponents = URLComponents(string: basePath + method)
        urlComponents?.queryItems = queryItemConversion
        return urlComponents?.url
    }
    
    var queryItems: [String: String] {
        return ["app_id": "25bc7dbb48da45af9ce2eae5f93eb257"]
    }
    
    var queryItemConversion: [URLQueryItem] {
        return queryItems.map({URLQueryItem(name: $0.key, value: $0.value)})
    }
}


enum PayPayRequestHandler: Requestable {
    
    case latestJSON
    case convert(value: Double, from: String, to: String)
    case currencies

    var method: String {
        switch self {
        case .latestJSON:
            return "latest.json"
        case .convert(let value, let from, let to):
            return "\(value)/\(from)/\(to)"
        case .currencies:
            return "currencies.json"
        }
    }
    
    var httpType: String {
        return "get"
    }
}

enum RequestErrorHandler: Error {
    case urlNotfound
    case noData
    case error(String)
    case noFileExist
}


enum APIState {
    case loading
    case data
    case none
    case error(RequestErrorHandler)
    
    func isLoading() -> Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
}
