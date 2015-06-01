//
//  ComplexArrayMatcher.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 10/05/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation
import SwiftMath
import Nimble

// Using Nimble's default delta constant
let DefaultDelta = 0.0001

public func isCloseTo<T: RealType>(actual: Complex<T>, expected: Complex<T>) -> Bool {
    return abs(actual - expected) < T(DefaultDelta)
}

public func beCloseTo<T: RealType>(expectedValue: [Complex<T>]) -> MatcherFunc<[Complex<T>]> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be close to <\(expectedValue)>"
        if let value = actualExpression.evaluate() {
            return reduce(zip(value, expectedValue), 0) {
                (allEqual: Int, values: (actual: Complex<T>, expected: Complex<T>)) in
                allEqual + (isCloseTo(values.actual, values.expected) ? 1 : 0)
            } == expectedValue.count
        } else {
            return false
        }
    }
}