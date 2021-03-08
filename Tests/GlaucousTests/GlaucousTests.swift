import XCTest
@testable import Glaucous

final class GlaucousTests: XCTestCase {
    func testAnalyticsEventTrigger() throws {
        // Given
        let sut = AnalyticsLogger.shared
        let provider = AnalyticsProviderMock()
        let events: [AnalyticsEvent] = AnalyticsEventMock.allCases
        sut.registerProvider(provider, events: events)

        // When
        sut.logEvent(event: AnalyticsEventMock.eventTest, parameters: ["key1" : "value1"])

        //Then
        XCTAssertTrue(provider.logEventCalled)
        XCTAssertEqual(provider.parameters!.first!.key, "key1")
        XCTAssertEqual(provider.parameters!.first!.value as! String, "value1")
        XCTAssertEqual(provider.eventName, AnalyticsEventMock.eventTest.name())
    }

    func testNewInstanceOfAnalyticsEvent() throws {
        // Given
        let sut = AnalyticsLogger.shared
        let provider = AnalyticsProviderMock()
        let events: [AnalyticsEvent] = AnalyticsEventMock.allCases
        sut.registerProvider(provider, events: events)

        // When
        sut.logEvent(event: AnalyticsEventMock.eventTest, parameters: ["key1" : "value1"])

        //Then
        XCTAssertTrue(provider.logEventCalled)
        XCTAssertEqual(provider.parameters!.first!.key, "key1")
        XCTAssertEqual(provider.parameters!.first!.value as! String, "value1")
        XCTAssertEqual(provider.eventName, AnalyticsEventMock.eventTest.name())
    }

    static var allTests = [
        ("testAnalyticsEventTrigger", testAnalyticsEventTrigger),
        ("testNewInstanceOfAnalyticsEvent", testNewInstanceOfAnalyticsEvent),
    ]
}

class AnalyticsProviderMock: AnalyticsProvider {
    var logEventCalled = false
    var parameters: [String: Any]?
    var eventName: String = ""

    func logEvent(event: AnalyticsEvent, parameters: [String : Any]?) {
        self.logEventCalled = true
        self.parameters = parameters
        self.eventName = event.name()
    }
}

enum AnalyticsEventMock: String, AnalyticsEvent, CaseIterable {
    func name() -> String {
        return self.rawValue
    }

    case eventTest = "event_test"
}
