//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Set
import XCTest

final class MultisetCollectionTests: XCTestCase {
	func testIndexesElementsByMultiplicity() {
		XCTAssertEqual(Multiset(1, 1, 1, 2, 2, 3).map { _ in () }.count, 6)
	}
}
