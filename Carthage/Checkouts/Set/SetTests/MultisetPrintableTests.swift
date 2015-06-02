//  Copyright (c) 2014 Rob Rix. All rights reserved.

import XCTest
import Set

final class TestElement: NSObject, Printable, DebugPrintable {
	// MARK: Printable

	override var description: String {
		return __FUNCTION__
	}


	// MARK: DebugPrintable

	override var debugDescription: String {
		return __FUNCTION__
	}
}

final class MultisetPrintableTests: XCTestCase {
	func testDescription() {
		XCTAssertEqual(Multiset<Int>().description, "{}")
		let test = Multiset<TestElement>()
		XCTAssertEqual(Multiset(TestElement()).description, "{description}")
	}

	func testDebugDescription() {
		XCTAssertEqual(Multiset<Int>().debugDescription, "{}")
		XCTAssertEqual(Multiset(TestElement()).debugDescription, "{debugDescription}")
	}
}
