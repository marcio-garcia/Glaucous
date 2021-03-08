//
//  File.swift
//  
//
//  Created by Marcio Garcia on 08/03/21.
//

import Foundation

public protocol AnalyticsLogging {
    func registerProvider(_ provider: AnalyticsProvider, events: [AnalyticsEvent])
    func logEvent(event: AnalyticsEvent, parameters: [String: Any]?)
}

public class AnalyticsLogger: AnalyticsLogging {

    public static let shared = AnalyticsLogger()

    var events: [String: [AnalyticsProvider]] = [:]

    private init() {}

    public func registerProvider(_ provider: AnalyticsProvider, events: [AnalyticsEvent]) {
        provider.configure()
        events.forEach({ event in
            let key = event.name()
            if self.events[key] == nil {
                self.events[key] = []
            }
            self.events[key]?.append(provider)
        })
    }

    public func logEvent(event: AnalyticsEvent, parameters: [String: Any]? = nil) {
        guard let index = self.events.index(forKey: event.name()) else { return }
        let element = self.events[index]
        let providers = element.value
        providers.forEach { provider in
            provider.logEvent(event: event, parameters: parameters)
        }
    }
}
