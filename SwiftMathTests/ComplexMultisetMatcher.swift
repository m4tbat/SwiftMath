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
import Set

// Using the same value as Nimble's default delta constant
let DefaultDelta = 0.0001

public func isCloseTo<T: RealType>(actual: Complex<T>, _ expected: Complex<T>) -> Bool {
    return abs(actual - expected) < T(DefaultDelta)
}

public func beCloseTo<T: RealType>(var expectedValue: Multiset<Complex<T>>) -> MatcherFunc<Multiset<Complex<T>>> {
    print("Expected value is: \(expectedValue)")
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be close to <\(expectedValue)>"
        if let value = actualExpression.evaluate() {
            for element in value {
                var containedElement: Complex<T>? = nil
                if expectedValue.contains(element) {
                    containedElement = element
                } else {
                    for expectedElement in expectedValue {
                        if isCloseTo(element, expectedElement) {
                            containedElement = expectedElement
                            break
                        }
                    }
                }
                if containedElement != nil {
                    expectedValue.remove(containedElement!)
                } else {
                    return false
                }
            }
            print("Expected value NOW is: \(expectedValue)")
            return expectedValue.isEmpty
        } else {
            return false
        }
    }
}