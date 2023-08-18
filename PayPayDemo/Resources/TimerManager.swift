//
//  TimerManager.swift
//  CurrencyConverter
//
//  Created by Pradeep kumar on 14/8/23.
//

import Foundation


final class TimerManager {
    
    static let sharedIntance = TimerManager()
    private init(){}
    
    private(set) var currentTime: TimeInterval = 30*60 // 30 minutes
    
    var timer: Timer?
    var timeExceeds: (() -> ())?
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: currentTime, target: self, selector: #selector(self.refreshAPIs), userInfo: nil, repeats: false)
    }
    
    @objc func refreshAPIs() {
        timeExceeds?()
        end()
    }
    
    func end() {
        timer?.invalidate()
        timer = nil
    }
    
    func setTimer(_ time: TimeInterval) {
        currentTime = time
        start()
    }
}
