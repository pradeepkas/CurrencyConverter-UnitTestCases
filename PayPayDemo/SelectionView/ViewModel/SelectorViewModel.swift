//
//  SelectorViewModel.swift
//  CurrencyConverter
//

import Foundation

final class SelectorViewModel {
    
    let currencyList: [Currency]
    var filterData = [Currency]()
    
    private var currentState: APIState = .none {
        didSet {
            stateMonitor?(currentState)
        }
    }
    
    var stateMonitor: ((APIState) -> Void)?
    
    init(_ currencyList: [Currency]) {
        self.currencyList = currencyList
        self.filterData = currencyList
    }
    
    func filterData(_ searchTerm: String?) {
        guard let searchTerm = searchTerm else {return}
        currentState = .loading
        if searchTerm.isEmpty {
            self.filterData = self.currencyList
        } else {
            self.filterData = self.currencyList.filter({
                $0.fullFormCountry.lowercased().contains(searchTerm.lowercased()) ||
                $0.short.lowercased().contains(searchTerm.lowercased())})
        }
        currentState = .data
    }
        
}
