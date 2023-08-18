//
//  SelectViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Pradeep kumar on 14/8/23.
//

import XCTest
@testable import PayPayDemo


final class SelectViewModelTests: XCTestCase {

    var viewModel: SelectorViewModel!
    
    override func setUp() {
        let mockNetwork = MockNetworkRequest()
        mockNetwork.getCurrencies { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let list):
                self.viewModel = SelectorViewModel(Currency.getList(list))
            default:
                break
            }
        }
    }
    
    // check count
    func test_currencies_data_count() {
        XCTAssertEqual(viewModel.currencyList.count, 10)
    }
    
    // check sorting
    func test_currencies_sorting() {
        // first one
        XCTAssertEqual(viewModel.currencyList[0].short, "AED")
        
        // second one
        XCTAssertEqual(viewModel.currencyList[1].short, "AFN")
        
        // last one
        XCTAssertEqual(viewModel.currencyList.last?.short, "USD")
    }
    
    // 
    func test_currencies_searching_with_valid() {
        viewModel.filterData("dollar")
        
        //count
        XCTAssertEqual(viewModel.filterData.count, 2)
        
        //check filter data --
        XCTAssertEqual(viewModel.filterData[0].short, "AUD")

        XCTAssertEqual(viewModel.filterData[1].short, "USD")
    }
    
    func test_currencies_searching_with_inValid() {
        viewModel.filterData("invalid")
        
        //count
        XCTAssertEqual(viewModel.filterData.count, 0)
    }

}
