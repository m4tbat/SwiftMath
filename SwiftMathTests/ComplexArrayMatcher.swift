//
//  ComplexArrayMatcher.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 10/05/15.
//  Copyright (c) 2015 GlidingSwift. All rights reserved.
//

import Foundation
import SwiftMath
import Nimble

public func beCloseTo<T: RealType>(expectedValue: [Complex<T>]) -> MatcherFunc<[Complex<T>]> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be close to <\(expectedValue)>"
        if let value = actualExpression.evaluate() {
            return reduce(zip(value, expectedValue), 0) {
                (allEqual: Int, values: (actual: Complex<T>, expected: Complex<T>)) in
                allEqual + ((values.actual =~ values.expected) ? 1 : 0)
            } == expectedValue.count
        } else {
            return false
        }
    }
}