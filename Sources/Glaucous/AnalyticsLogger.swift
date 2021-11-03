//
//  File.swift
//  
//
//  Created by Marcio Garcia on 08/03/21.
//

import Foundation

public protocol AnalyticsLogging {
    func registerProvider(_ provider: AnalyticsProvider, events: [AnalyticsEvent])
    func setUserProperties(userId: String, name: String, email: String)
    func logEvent(event: AnalyticsEvent, parameters: [String: Any]?)
    func removeAll()
}

public class AnalyticsLogger: AnalyticsLogging {

    public static let shared = AnalyticsLogger()

    private var events: [String: [String]] = [:]
    private var providers: [AnalyticsProvider] = []

    private init() {}

    public func registerProvider(_ provider: AnalyticsProvider, events: [AnalyticsEvent]) {
        addProvider(provider)
        provider.configure()
        events.forEach({ event in
            let key = event.name()
            if self.events[key] == nil {
                self.events[key] = []
            }
            self.events[key]?.append(provider.identifier())
        })
    }

    public func setUserProperties(userId: String, name: String, email: String) {
        providers.forEach {
            $0.setUserProperties(id: userId, name: name, email: email)
        }
    }

    public func logEvent(event: AnalyticsEvent, parameters: [String: Any]? = nil) {
        guard let index = self.events.index(forKey: event.name()) else { return }
        let element = self.events[index]
        let providerIds = element.value
        providerIds.forEach { id in
            let firstIndex = providers.firstIndex { $0.identifier() == id }
            if let index = firstIndex {
                let provider = providers[index]
                provider.logEvent(event: event, parameters: parameters)
            }
        }
    }

    public func removeAll() {
        events.removeAll()
        providers.removeAll()
    }

    private func addProvider(_ provider: AnalyticsProvider) {
        let exists = providers.contains { $0.identifier() == provider.identifier() }
        if !exists {
            providers.append(provider)
        }
    }
}
