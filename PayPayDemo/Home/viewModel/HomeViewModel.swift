//
//  HomeViewModel.swift
//  CurrencyConverter
//
//  ""
//

import Foundation


final class HomeViewModel {
    
    private(set) var currencyList = [String: String]()
    private(set) var currencyRateList = [CurrencyRates]()
    private(set) var homeList = [HomeListData]()
    private(set) var selectedCurrency = "USD" // default one as base one

    let homeRequest: NetworkRequestHome
    let helperClass: HelperHanlder
    let localSaver: LocalData
    let timer: TimerManager = TimerManager.sharedIntance
    
    init(homeRequest: NetworkRequestHome = HomeReqeusts(),
         helperClass: HelperHanlder = Helper(),
         localSaver: LocalData = LocalHandler()) {
        self.homeRequest = homeRequest
        self.helperClass = helperClass
        self.localSaver = localSaver
    }
    
    private var currentState: APIState = .none {
        didSet {
            stateMonitor?(currentState)
        }
    }
    
    var stateMonitor: ((APIState) -> Void)?
    private let dispatchGroup = DispatchGroup()

    
    func fetchData() {
        currentState = .loading
        let timeDiff = helperClass.getMinutesDifferenceFromTwoDates(start: Date(timeIntervalSince1970: UserDefaults.differenceMinutesCurrency), end: Date())
        
        if timeDiff < 30 {
            self.currencyList = Currency.getFromLocal()
            self.currencyRateList = CurrencyRates.getFromLocal()
            self.currentState = .data
            self.timer.setTimer(TimeInterval((30 - timeDiff) * 60)) // timer for remaining time
            return
        }
            
        dispatchGroup.enter()
        getCurrenciesList()
        
        dispatchGroup.enter()
        getLatestCurrencyRates()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else {return}
            self.currentState = .data
            self.timer.start()
        }
    }
    
    private func getCurrenciesList() {
        homeRequest.getCurrencies { [weak self] results in
            guard let self = self else {return}
            switch results {
            case .success(let list):
                self.currencyList = list
                self.localSaver.saveCurrencies(list)
            case .failure(let error):
                self.currentState = .error(.error(error.localizedDescription))
            }
            self.dispatchGroup.leave()
        }
    }
    
    
    private func getLatestCurrencyRates() {
        homeRequest.getCurrenciesRates { [weak self] results in
            guard let self = self else {return}
            switch results {
            case .success(let data):
                self.currencyRateList = CurrencyRates.getList(data.rates)
                self.localSaver.saveCurrenciesRates(data.rates)
            case .failure(let error):
                self.currentState = .error(.error(error.localizedDescription))
            }
            self.dispatchGroup.leave()
        }
    }
    
    // after selected currency from selection screen
    func updateSelectedCurrency(_ data: Currency) {
        self.selectedCurrency = data.short
    }
    
    // after entering number in text field
    func udpateDataAfterTextFieldUpdate(_ text: String) {
        if let number = Double(text), number != 0 {
            self.updateHomeListData(number)
        } else {
            homeList = []
            currentState = .data
        }
    }
    
    private func updateHomeListData(_ currentNumber: Double) {
        currentState = .loading
        homeList = []
        // handle if not exist in rate list
        guard let selectedCurrencyRate = currencyRateList.filter({$0.currenecyName == selectedCurrency}).first else {
            print("selected Currency does not exist, so will update from local")
            self.currentNotExistFetchFromLocal(currentNumber)
            return
        }
        updateHomeListForSelectedCurrency(selectedCurrencyRate, currentNumber: currentNumber)
    }
    
    private func updateHomeListForSelectedCurrency(_ selectedCurrencyRate: CurrencyRates,
                                                   currentNumber: Double) {
        for ele in currencyRateList {
            if ele.currenecyName == selectedCurrency {continue}
            let fullName = currencyList[ele.currenecyName] ?? ""
            let currencyRate = (ele.currencyRate / selectedCurrencyRate.currencyRate) * currentNumber
            let data = HomeListData(shortName: ele.currenecyName, fullName: fullName, currencyRate: currencyRate)
            homeList.append(data)
        }
        homeList = homeList.sorted(by: {$0.shortName < $1.shortName})
        currentState = .data
    }
    
    // in some cases selected currencny not coming from reqeust so using local data
    private func currentNotExistFetchFromLocal(_ currentNumber: Double) {
        let network = NetworkManager(URLSessionPay(true))
        let mockRequest = MockData.currencyList.getRequest()
        network.getData(type: [String: Double].self, request: mockRequest) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let data):
                let currenctRates = data[self.selectedCurrency] ?? 0
                self.updateHomeListForSelectedCurrency(CurrencyRates.init(currenecyName: self.selectedCurrency, currencyRate: currenctRates), currentNumber: currentNumber)
            case .failure(let error):
                self.currentState = .error(.error(error.localizedDescription))
            }
        }
    }
    
    func timerManager() {
        timer.timeExceeds = { [weak self] in
            guard let self = self else {return}
            self.getCurrenciesList()
            self.getLatestCurrencyRates()
            self.timer.start()
        }
    }
}
