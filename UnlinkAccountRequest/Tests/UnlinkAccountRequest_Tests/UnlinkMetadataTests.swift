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
}

