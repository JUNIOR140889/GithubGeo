import XCTest
@testable import UnlinkAccountRequest

final class UnlinkMetadataTests: XCTestCase {
    func testDecodesDialAction() throws {
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
        XCTAssertEqual(metadata.title, "Need help?")
        XCTAssertEqual(metadata.message, "Call us")
        XCTAssertEqual(metadata.action.type, .dial)
        XCTAssertEqual(metadata.action.name, "Call")
        XCTAssertEqual(metadata.action.metadata.phone, "123456789")
    }

    func testDecodesURLAction() throws {
        let json = """
        {
            "title": "Visit us",
            "message": "Open website",
            "action": {
                "type": "url",
                "name": "Website",
                "data": {
                    "link": "https://example.com"
                }
            }
        }
        """.data(using: .utf8)!

        let metadata = try JSONDecoder().decode(UnlinkMetadata.self, from: json)
        XCTAssertEqual(metadata.title, "Visit us")
        XCTAssertEqual(metadata.message, "Open website")
        XCTAssertEqual(metadata.action.type, .url)
        XCTAssertEqual(metadata.action.name, "Website")
        XCTAssertEqual(metadata.action.metadata.link, "https://example.com")
    }

    func testDecodesInvalidActionType() throws {
        let json = """
        {
            "title": "Need help?",
            "message": "Unknown action",
            "action": {
                "type": "whatever",
                "name": "Invalid",
                "data": {
                    "link": "https://example.com"
                }
            }
        }
        """.data(using: .utf8)!

        let metadata = try JSONDecoder().decode(UnlinkMetadata.self, from: json)
        XCTAssertEqual(metadata.action.type, .invalid)
    }

    func testMissingDataThrowsError() throws {
        let json = """
        {
            "title": "Need help?",
            "message": "No data",
            "action": {
                "type": "url",
                "name": "Website"
            }
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(UnlinkMetadata.self, from: json)) { error in
            guard case DecodingError.keyNotFound(let key, _) = error else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(key.stringValue, "data")
        }
    }
}

