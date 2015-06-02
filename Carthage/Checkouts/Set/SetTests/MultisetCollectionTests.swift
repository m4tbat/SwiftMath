//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Set
import XCTest

final class MultisetCollectionTests: XCTestCase {
	func testIndexesElementsByMultiplicity() {
		XCTAssertEqual(map(Multiset(1, 1, 1, 2, 2, 3)) { _ in () }.count, 6)
	}
}
