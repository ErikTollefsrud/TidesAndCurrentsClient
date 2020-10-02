import XCTest
@testable import TidesAndCurrentsClient
@testable import TidesAndCurrentsClientLive

final class TidesAndCurrentsClientTests: XCTestCase {
    func testExample() {
        let client = TidesClient.mock
        let test = client.stations()
        XCTAssertEqual(client.stations, <#T##expression2: Equatable##Equatable#>)
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
