//  Copyright (c) 2015 Rob Rix. All rights reserved.

import Set
import XCTest

final class MultisetInclusionTests: XCTestCase {
	func testSubset() {
		XCTAssert(Multiset(1).subset(Multiset(1, 2, 3)))
	}

	func testStrictSubset() {
		XCTAssert(Multiset(1).strictSubset(Multiset(1, 2)))
		XCTAssertFalse(Multiset(1).strictSubset(Multiset(1)))
	}

	func testSubsetIncludesSelf() {
		XCTAssert(Multiset(1, 2, 3).subset(Multiset(1, 2, 3)))
	}

	func testSubsetIncludesSmallerMultiplicities() {
		XCTAssert(Multiset(1, 2, 3).subset(Multiset(1, 1, 2, 3)))
	}

	func testStrictSupersetIsNotSubset() {
		XCTAssertFalse(Multiset(1, 2, 3, 4).subset(Multiset(1, 2, 3)))
	}

	func testEmptySetIsAlwaysSubset() {
		XCTAssert(Multiset().subset(Multiset<Int>()))
		XCTAssert(Multiset().subset(Multiset(1, 2, 3)))
	}

	func testSuperset() {
		XCTAssert(Multiset(1, 2, 3).superset(Multiset(1)))
	}

	func testStrictSuperset() {
		XCTAssert(Multiset(1, 2).strictSuperset(Multiset(1)))
		XCTAssertFalse(Multiset(1).strictSuperset(Multiset(1)))
	}

	func testSupersetIncludesSelf() {
		XCTAssert(Multiset(1, 2, 3).superset(Multiset(1, 2, 3)))
	}

	func testSupersetIncludesLargerMultiplicities() {
		XCTAssert(Multiset(1, 1, 2, 3).superset(Multiset(1, 2, 3)))
	}

	func testStrictSubsetIsNotSuperset() {
		XCTAssertFalse(Multiset(1, 2, 3).superset(Multiset(1, 2, 3, 4)))
	}

	func testAlwaysSupersetOfEmptySet() {
		XCTAssert(Multiset<Int>().superset(Multiset()))
		XCTAssert(Multiset(1, 2, 3).superset(Multiset()))
	}
}
