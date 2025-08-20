import XCTest
import APIKit
@testable import UnlinkAccountRequest

final class WorkerTests: XCTestCase {
    func testUnlinkInvokesTargetAndDecodesResponse() {
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

        let mockProvider = MockAPIProvider<UnlinkRequest>(result: .success(json))
        let worker = Worker(apiProvider: AnyAPIProvider<UnlinkRequest>(mockProvider))

        let expectation = self.expectation(description: "Completion called")
        worker.unlink { result in
            switch result {
            case .success(let metadata):
                XCTAssertEqual(metadata.title, "Need help?")
                XCTAssertEqual(metadata.message, "Call us")
                XCTAssertEqual(metadata.action.type, .dial)
                XCTAssertEqual(metadata.action.metadata.phone, "123456789")
            default:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }

        XCTAssertEqual(mockProvider.lastTarget, .unlink)
        wait(for: [expectation], timeout: 1.0)
    }

    func testUnlinkPropagatesNetworkError() {
        enum MockError: Error { case failure }
        let mockProvider = MockAPIProvider<UnlinkRequest>(result: .failure(MockError.failure))
        let worker = Worker(apiProvider: AnyAPIProvider<UnlinkRequest>(mockProvider))

        let expectation = self.expectation(description: "Completion called")
        worker.unlink { result in
            if case .failure(let error as MockError) = result {
                XCTAssertEqual(error, .failure)
            } else {
                XCTFail("Expected failure")
            }
            expectation.fulfill()
        }

        XCTAssertEqual(mockProvider.lastTarget, .unlink)
        wait(for: [expectation], timeout: 1.0)
    }

    func testUnlinkPropagatesDecodingError() {
        let data = Data("invalid".utf8)
        let mockProvider = MockAPIProvider<UnlinkRequest>(result: .success(data))
        let worker = Worker(apiProvider: AnyAPIProvider<UnlinkRequest>(mockProvider))

        let expectation = self.expectation(description: "Completion called")
        worker.unlink { result in
            switch result {
            case .failure:
                break
            default:
                XCTFail("Expected failure")
            }
            expectation.fulfill()
        }

        XCTAssertEqual(mockProvider.lastTarget, .unlink)
        wait(for: [expectation], timeout: 1.0)
    }
}

final class MockAPIProvider<Target: TargetType>: APIProviderProtocol {
    var lastTarget: Target?
    let result: Result<Data, Error>

    init(result: Result<Data, Error>) {
        self.result = result
    }

    func perform(_ target: Target, didSucceed: @escaping (Data) -> Void, didFail: @escaping (Error) -> Void) {
        lastTarget = target
        switch result {
        case .success(let data):
            didSucceed(data)
        case .failure(let error):
            didFail(error)
        }
    }
}
