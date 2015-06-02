//  Copyright (c) 2015 Rob Rix. All rights reserved.

import XCTest
import Set

final class MultisetSequenceTests: XCTestCase {
	func testGeneratorProducesEveryElement() {
		XCTAssertEqual(sorted(Array(Multiset(0, 1, 2))), [ 0, 1, 2 ])
	}

	func testGeneratorProducesElementsByMultiplicity() {
		XCTAssertEqual(reduce(Multiset(1, 1, 1, 2, 2, 3), 0, +), 10)
	}
}
