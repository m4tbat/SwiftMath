//  Copyright (c) 2015 Rob Rix. All rights reserved.

import XCTest
import Set

final class MultisetSequenceTests: XCTestCase {
	func testGeneratorProducesEveryElement() {
		XCTAssertEqual(Array(Multiset(0, 1, 2)).sort(), [ 0, 1, 2 ])
	}

	func testGeneratorProducesElementsByMultiplicity() {
		XCTAssertEqual(Multiset(1, 1, 1, 2, 2, 3).reduce(0, +), 10)
	}
}
