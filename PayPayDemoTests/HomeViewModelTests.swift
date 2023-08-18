//
//  HomeViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Pradeep kumar on 14/8/23.
//

import XCTest
@testable import PayPayDemo

final class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!
    
    // Initial setup
    override func setUp() {
        viewModel = HomeViewModel(homeRequest: MockNetworkRequest(), helperClass: MockHelper(), localSaver: LocalSaverMock())
        viewModel.fetchData()
    }
    
    func test_data_with_base_cases_with_for_count() {
        // update data for base case means USD one
        viewModel.udpateDataAfterTextFieldUpdate("1")
        
        //currencyRateList count
        XCTAssertEqual(viewModel.currencyRateList.count, 10)
        
        //currencyList count
        XCTAssertEqual(viewModel.currencyList.count, 10)
        
        //homeList -- total currencies is 10 so home list will contain only 9 (10 - selectedone)
        XCTAssertEqual(viewModel.homeList.count, 9)
    }
    
    func test_data_with_base_case_currency_list() {
        viewModel.udpateDataAfterTextFieldUpdate("1")
        
        // check for AUD
        XCTAssertEqual(viewModel.currencyList["AUD"], "Australian Dollar")
        
        // check for USD
        XCTAssertEqual(viewModel.currencyList["USD"], "United States Dollar")
        
        // check for INR
        XCTAssertEqual(viewModel.currencyList["INR"], "Indian Rupee")
    }
    
    
    func test_data_with_base_case_currency_list_rates() {
        
        viewModel.udpateDataAfterTextFieldUpdate("1")
        
        // check for AUD
        let AUDRates = viewModel.currencyRateList.filter({$0.currenecyName == "AUD"}).first
        XCTAssertEqual(1.53825, AUDRates?.currencyRate)
        
        // check for USD
        let USDRates = viewModel.currencyRateList.filter({$0.currenecyName == "USD"}).first
        XCTAssertEqual(1.0, USDRates?.currencyRate)
        
        // check for INR
        let INRRates = viewModel.currencyRateList.filter({$0.currenecyName == "INR"}).first
        XCTAssertEqual(82.95745, INRRates?.currencyRate)
    }
    
    // with textfiled entry as 1 when INR selected as base
    func test_data_with_INR_selected_currency_1() {
        
        // fetch INR currency -- given
        let currencies = Currency.getList(viewModel.currencyList)
        let INRCurrency = currencies.filter({$0.short == "INR"})[0]
        
        //when
        viewModel.updateSelectedCurrency(INRCurrency)
        viewModel.udpateDataAfterTextFieldUpdate("1")
        
        //check currencies rates
        
        // check for AUD
        let AUDRates = viewModel.homeList.filter({$0.shortName == "AUD"}).first
        XCTAssertEqual(0.01854263842487926, AUDRates?.currencyRate)
        
        // check for USD
        let USDRates = viewModel.homeList.filter({$0.shortName == "USD"}).first
        XCTAssertEqual(0.012054372452383723, USDRates?.currencyRate)
        
        // check for INR ---> now its base .. so it will not exist in list
        let INRRates = viewModel.homeList.filter({$0.shortName == "INR"}).first
        XCTAssertEqual(nil, INRRates?.currencyRate)
    }
    
    // with textfiled entry as 150 when INR selected as base
    func test_data_with_INR_selected_currency_150() {
        
        // fetch INR currency -- given
        let currencies = Currency.getList(viewModel.currencyList)
        let INRCurrency = currencies.filter({$0.short == "INR"})[0]
        
        //when
        viewModel.updateSelectedCurrency(INRCurrency)
        viewModel.udpateDataAfterTextFieldUpdate("150")
        
        //check currencies rates
        // check for AUD
        let AUDRates = viewModel.homeList.filter({$0.shortName == "AUD"}).first
        XCTAssertEqual(2.781395763731889, AUDRates?.currencyRate)
        
        // check for USD
        let USDRates = viewModel.homeList.filter({$0.shortName == "USD"}).first
        XCTAssertEqual(1.8081558678575584, USDRates?.currencyRate)
        
        // check for INR ---> now its base .. so it will not exist in list
        let INRRates = viewModel.homeList.filter({$0.shortName == "INR"}).first
        XCTAssertEqual(nil, INRRates?.currencyRate)
    }
    
    // with textfiled entry as invalid  when INR selected as base --> 150.00.00
    func test_data_with_INR_selected_currency_invalid_entry() {
        
        // fetch INR currency -- given
        let currencies = Currency.getList(viewModel.currencyList)
        let INRCurrency = currencies.filter({$0.short == "INR"})[0]
        
        //when
        viewModel.updateSelectedCurrency(INRCurrency)
        viewModel.udpateDataAfterTextFieldUpdate("150.00.00") // invalid data
        
        //check currencies rates
        // check for AUD
        let AUDRates = viewModel.homeList.filter({$0.shortName == "AUD"}).first
        XCTAssertEqual(nil, AUDRates?.currencyRate)
        
        // check for USD
        let USDRates = viewModel.homeList.filter({$0.shortName == "USD"}).first
        XCTAssertEqual(nil, USDRates?.currencyRate)
        
        // check for INR ---> now its base .. so it will not exist in list
        let INRRates = viewModel.homeList.filter({$0.shortName == "INR"}).first
        XCTAssertEqual(nil, INRRates?.currencyRate)

    }
    
    // with textfiled entry as blank/empty  when INR selected as base
    func test_data_with_INR_selected_currency_empty_entry() {
        
        // fetch INR currency -- given
        let currencies = Currency.getList(viewModel.currencyList)
        let INRCurrency = currencies.filter({$0.short == "INR"})[0]
        
        //when
        viewModel.updateSelectedCurrency(INRCurrency)
        viewModel.udpateDataAfterTextFieldUpdate("") // empty data
        
        //check currencies rates
        // check for AUD
        let AUDRates = viewModel.homeList.filter({$0.shortName == "AUD"}).first
        XCTAssertEqual(nil, AUDRates?.currencyRate)
        
        // check for USD
        let USDRates = viewModel.homeList.filter({$0.shortName == "USD"}).first
        XCTAssertEqual(nil, USDRates?.currencyRate)
        
        // check for INR ---> now its base .. so it will not exist in list
        let INRRates = viewModel.homeList.filter({$0.shortName == "INR"}).first
        XCTAssertEqual(nil, INRRates?.currencyRate)

    }

    
    func test_data_with_base_case_check_sorting_homelist() {
        viewModel.udpateDataAfterTextFieldUpdate("1")

        // check for AED
        XCTAssertEqual(viewModel.homeList[0].shortName , "AED")
        
        // check for AFN
        XCTAssertEqual(viewModel.homeList[1].shortName , "AFN")

        // check for INR
        XCTAssertEqual(viewModel.homeList.last?.shortName , "INR")
    }

}
