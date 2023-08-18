//
//  MockHelper.swift
//  CurrencyConverterTests
//
//  Created by Pradeep kumar on 14/8/23.
//

import Foundation
@testable import PayPayDemo


// mocking local data usage time check
class MockHelper: HelperHanlder {
    func getMinutesDifferenceFromTwoDates(start: Date, end: Date) -> Int {
        return 35 // so that it will fetch data always from local
    }
}
