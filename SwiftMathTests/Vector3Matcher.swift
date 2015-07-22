//
//  VectorR3Matcher.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 01/06/15.
//  Copyright (c) 2015 GlidingSwift. All rights reserved.
//

import Foundation
import SwiftMath
import Nimble

public func isCloseTo<T: RealType>(actual: Vector3<T>, _ expected: Vector3<T>) -> Bool {
    let diff = actual - expected
    return diff.x.abs < T(DefaultDelta) &&
        diff.y.abs < T(DefaultDelta) &&
        diff.z.abs < T(DefaultDelta)
}

public func beCloseTo<T: RealType>(expectedValue: Vector3<T>) -> MatcherFunc<Vector3<T>> {
    return MatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be close to <\(expectedValue)>"
        if let value = actualExpression.evaluate() {
            return isCloseTo(value, expectedValue)
        } else {
            return false
        }
    }
}