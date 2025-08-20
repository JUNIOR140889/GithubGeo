import XCTest
@testable import UnlinkAccountRequest

final class UnlinkRequestTests: XCTestCase {
    func testUnlinkRequestProperties() {
        let request = UnlinkRequest.unlink
        XCTAssertEqual(request.path, "/api/account/unlink")
        XCTAssertEqual(request.method, .get)
        XCTAssertNil(request.parameters)
        XCTAssertTrue(request.authorized)
        XCTAssertEqual(request.contentType, .applicationJSON)
        XCTAssertEqual(request.sourceType, .default)
    }
}

