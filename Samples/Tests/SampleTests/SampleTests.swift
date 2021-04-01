import XCTest
@testable import Sample

final class SampleTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Sample().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
