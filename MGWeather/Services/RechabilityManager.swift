//
//  RechabilityManager.swift
//  MGWeather
//
//  Created by Michael Ghevondyan on 21.04.23.
//

import UIKit
import Reachability

public final class ReachabilityManager: NSObject {

  //MARK: - Shared instance
    
  static let shared = ReachabilityManager()
  
  // MARK: Private properties
    
  private let reachability = try! Reachability()

  private override init() {
    super.init()
    reachability.whenReachable = { status in
    }
    reachability.whenUnreachable = { status in
    }
    startListening()
  }
  
  deinit {
    reachability.stopNotifier()
  }
  
  //MARK: Public
    
  func isReachable() -> Bool {
    return reachability.connection == .unavailable ? false : true
  }
  
  func startListening() {
    try? reachability.startNotifier()
  }
}
