import XCTest
@testable import UnlinkAccountRequest

final class UnlinkAccountTests: XCTestCase {

    private final class WorkerMock: WorkerProtocol {
        let result: Result<UnlinkMetadata, Error>

        init(result: Result<UnlinkMetadata, Error>) {
            self.result = result
        }

        func unlink(onCompletion: ((Result<UnlinkMetadata, Error>) -> Void)?) {
            onCompletion?(result)
        }
    }

    func testExecuteReturnsUnlinkResultOnSuccess() throws {
        let json = """
        {
            "title": "Need help?",
            "message": "Call us",
            "action": {
                "type": "url",
                "name": "Support",
                "data": { "link": "https://example.com" }
            }
        }
        """.data(using: .utf8)!

        let metadata = try JSONDecoder().decode(UnlinkMetadata.self, from: json)
        let unlinkAccount = UnlinkAccount(worker: WorkerMock(result: .success(metadata)))

        let expectation = self.expectation(description: "completion")

        unlinkAccount.execute { result in
            switch result {
            case .success(let unlinkResult):
                XCTAssertEqual(unlinkResult.title, metadata.title)
                XCTAssertEqual(unlinkResult.message, metadata.message)
                XCTAssertEqual(unlinkResult.actionTitle, metadata.action.name)
                XCTAssertEqual(unlinkResult.action.absoluteString, metadata.action.metadata.link!)
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testExecutePropagatesWorkerError() {
        struct SampleError: Error {}

        let unlinkAccount = UnlinkAccount(worker: WorkerMock(result: .failure(SampleError())))

        let expectation = self.expectation(description: "completion")

        unlinkAccount.execute { result in
            switch result {
            case .success:
                XCTFail("Expected failure")
            case .failure(let error):
                XCTAssertTrue(error is SampleError)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }
}

