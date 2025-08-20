import XCTest
@testable import UnlinkAccountRequest

private enum FatalErrorUtil {
    typealias FatalErrorClosure = (String, StaticString, UInt) -> Never
    static var fatalErrorClosure: FatalErrorClosure = defaultFatalErrorClosure
    private static let defaultFatalErrorClosure: FatalErrorClosure = { Swift.fatalError($0, file: $1, line: $2) }
    static func replaceFatalError(closure: @escaping FatalErrorClosure) {
        fatalErrorClosure = closure
    }
    static func restoreFatalError() {
        fatalErrorClosure = defaultFatalErrorClosure
    }
}

func fatalError(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Never {
    FatalErrorUtil.fatalErrorClosure(message(), file, line)
}

extension XCTestCase {
    func expectFatalError(expectedMessage: String, testcase: @escaping () -> Void) {
        let expectation = self.expectation(description: "Expecting fatalError")
        FatalErrorUtil.replaceFatalError { message, _, _ in
            XCTAssertEqual(message, expectedMessage)
            expectation.fulfill()
            repeat { RunLoop.current.run() } while true
        }

        DispatchQueue.global(qos: .userInitiated).async(execute: testcase)

        waitForExpectations(timeout: 0.1) { _ in
            FatalErrorUtil.restoreFatalError()
        }
    }
}

final class UnlinkResultTests: XCTestCase {
    func testURLAction() throws {
        let json = """
        {
            "title": "Title",
            "message": "Message",
            "action": {
                "type": "url",
                "name": "Open",
                "data": {
                    "link": "https://example.com/path"
                }
            }
        }
        """.data(using: .utf8)!
        let metadata = try JSONDecoder().decode(UnlinkMetadata.self, from: json)
        let result = UnlinkResult(metadata: metadata)
        XCTAssertEqual(result.action, URL(string: "https://example.com/path"))
        XCTAssertEqual(result.actionTitle, "Open")
        XCTAssertEqual(result.title, "Title")
        XCTAssertEqual(result.message, "Message")
    }

    func testDialAction() throws {
        let json = """
        {
            "title": "Need help?",
            "message": "Call us",
            "action": {
                "type": "dial",
                "name": "Call",
                "data": {
                    "phone": "123456789"
                }
            }
        }
        """.data(using: .utf8)!
        let metadata = try JSONDecoder().decode(UnlinkMetadata.self, from: json)
        let result = UnlinkResult(metadata: metadata)
        XCTAssertEqual(result.action, URL(string: "tel://123456789"))
        XCTAssertEqual(result.actionTitle, "Call")
        XCTAssertEqual(result.title, "Need help?")
        XCTAssertEqual(result.message, "Call us")
    }

    func testInvalidActionTriggersFatalError() throws {
        let json = """
        {
            "title": "Oops",
            "message": "No action",
            "action": {
                "type": "unknown",
                "name": "N/A",
                "data": {}
            }
        }
        """.data(using: .utf8)!
        let metadata = try JSONDecoder().decode(UnlinkMetadata.self, from: json)
        expectFatalError(expectedMessage: "Action should be setted at this point") {
            _ = UnlinkResult(metadata: metadata)
        }
    }
}
