//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import Set

final class MultisetInitializerTests: XCTestCase {
	func testVariadic() {
		XCTAssert(Multiset(1) == Multiset([1]))
		XCTAssert(Multiset(1, 2, 3) == Multiset([1, 2, 3]))
	}

	func testMinimumCapacity() {
		XCTAssert(Multiset<Int>(minimumCapacity: 4).isEmpty)
	}
}
