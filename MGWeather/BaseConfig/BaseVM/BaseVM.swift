//
//  BaseVM.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 19.04.23.
//

import Foundation

protocol VMToVCExchange: AnyObject {
    func dataFetched<T>(type: T.Type, data: [T], observerName: String)
    func dataFetched<T>(type: T.Type, data: T, observerName: String)
    func invalidDataErrorReceived<T>(fieldType: T.Type, data: [String: String])
    func errorReceived(error: NetworkError)
}

class BaseVM {
    
    weak var baseDelegate: VMToVCExchange?
    func checkInternet() -> Bool {
        guard ReachabilityManager.shared.isReachable() else {
            self.baseDelegate?.invalidDataErrorReceived(fieldType: CountryModel.self, data: ["No Netvork" : "Plase check your internet connection and try again."])
            return false
        }
        return true
    }
    
}

extension BaseVM: VMToVCExchange {
    func dataFetched<T>(type: T.Type, data: [T], observerName: String) {
        
    }
    
    func dataFetched<T>(type: T.Type, data: T, observerName: String) {
        
    }
    
    func invalidDataErrorReceived<T>(fieldType: T.Type, data: [String: String]) {
        
    }
    
    func errorReceived(error: NetworkError) {
        
    }
    
    func dataFetched<T>(type: T.Type, data: [T]) {
        
    }
    
    func dataFetched<T>(type: T.Type, data: T) {
        
    }
}
