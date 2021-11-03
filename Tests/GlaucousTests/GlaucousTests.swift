import XCTest
@testable import Glaucous

final class GlaucousTests: XCTestCase {

    var sut: AnalyticsLogging!
    var provider: AnalyticsProviderMock!
    var events: [AnalyticsEvent] = []

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = AnalyticsLogger.shared
        provider = AnalyticsProviderMock()
        events = AnalyticsEventMock.allCases
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut.removeAll()
    }

    func testAnalyticsEventTrigger() throws {
        // Given
        sut.registerProvider(provider, events: events)

        // When
        sut.logEvent(event: AnalyticsEventMock.eventTest, parameters: ["key1" : "value1"])

        //Then
        XCTAssertTrue(provider!.logEventCalled)
        XCTAssertEqual(provider!.parameters!.first!.key, "key1")
        XCTAssertEqual(provider!.parameters!.first!.value as! String, "value1")
        XCTAssertEqual(provider!.eventName, AnalyticsEventMock.eventTest.name())
    }

    func testSetUserProperties() throws {
        // Given
        sut.registerProvider(provider, events: events)

        // When
        sut.setUserProperties(userId: "1", name: "User Name", email: "email@host.com")

        //Then
        XCTAssertTrue(provider.setUserPropertiesCalled)
        XCTAssertEqual(provider.userId, "1")
        XCTAssertEqual(provider.name, "User Name")
        XCTAssertEqual(provider.email, "email@host.com")
    }

    static var allTests = [
        ("testAnalyticsEventTrigger", testAnalyticsEventTrigger),
        ("testSetUserProperties", testSetUserProperties),
    ]
}

class AnalyticsProviderMock: AnalyticsProvider {
    var logEventCalled = false
    var parameters: [String: Any]?
    var eventName: String = ""
    var setUserPropertiesCalled = false
    var userId: String = ""
    var name: String = ""
    var email: String = ""

    func identifier() -> String {
        return String(describing: AnalyticsProviderMock.self)
    }

    func setUserProperties(id: String, name: String, email: String) {
        setUserPropertiesCalled = true
        self.userId = id
        self.name = name
        self.email = email
    }

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
