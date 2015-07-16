//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import Set

final class MultisetHigherOrderFunctionTests: XCTestCase {
	func testFilter() {
		XCTAssert(Multiset(1, 2, 3).filter { $0 == 2 } == Multiset(2))
	}

	func testReducible() {
		XCTAssert(Multiset(1, 2, 3).reduce(0, +) == 6)
	}

	func testMappable() {
		XCTAssert(Multiset(1, 2, 3).map(String.init) == Multiset("1", "2", "3"))
	}

	func testFlatMapReturnsTheUnionOfAllResultingSets() {
		XCTAssertEqual(Multiset(1, 2).flatMap { [$0, $0 * 2] }, Multiset(1, 2, 2, 4))
	}
}
