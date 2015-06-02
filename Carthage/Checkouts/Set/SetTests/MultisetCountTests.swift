//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Set
import XCTest

final class MultisetCountTests: XCTestCase {
	func testCountSumsElementsMultiplicities() {
		XCTAssertEqual(Multiset(0, 1, 1).count, 3)
	}

	func testCountOfAnElementIsItsMultiplicity() {
		XCTAssertEqual(Multiset(0, 1, 1).count(1), 2)
	}

	func testContainsIsTrueWhenCountIsGreaterThanZero() {
		XCTAssert(Multiset(0, 1, 1).contains(0))
		XCTAssert(Multiset(0, 1, 1).contains(1))
		XCTAssertFalse(Multiset(0, 1, 1).contains(2))
	}

	func testNullMultisetIsEmpty() {
		XCTAssert(Multiset<Int>().isEmpty)
	}

	func testNonNullConstructedMultisetIsNotEmpty() {
		XCTAssertFalse(Multiset(0).isEmpty)
	}

	func testNullConstructedMultisetIsNotEmptyAfterInsertion() {
		var set = Multiset<Int>()
		set.insert(0)
		XCTAssertFalse(set.isEmpty)
	}

	func testNonNullConstructedMultisetIsEmptyAfterRemoval() {
		var set = Multiset(0)
		set.remove(0)
		XCTAssert(set.isEmpty)
	}
}
