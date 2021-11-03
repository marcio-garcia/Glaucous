//
//  File.swift
//  
//
//  Created by Marcio Garcia on 08/03/21.
//

import Foundation

public protocol AnalyticsProvider {
    func configure()
    func identifier() -> String
    func setUserProperties(id: String, name: String, email: String)
    func logEvent(event: AnalyticsEvent, parameters: [String: Any]?)
}

public extension AnalyticsProvider {
    func configure() { }
}
