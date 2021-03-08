//
//  File.swift
//  
//
//  Created by Marcio Garcia on 08/03/21.
//

import Foundation

public protocol AnalyticsProvider {
    func configure()
    func logEvent(event: AnalyticsEvent, parameters: [String: Any]?)
}

public extension AnalyticsProvider {
    func configure() { }
}
