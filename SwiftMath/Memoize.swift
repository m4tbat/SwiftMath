//
//  Memoize.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 25/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public func memoize<Input: Hashable, Output>(fn: Input -> Output) -> (Input) -> Output {
    var cache = [Input: Output]()
    return { val in
        if let value = cache[val] {
            return value
        } else {
            let newValue = fn(val)
            cache[val] = newValue
            return newValue
        }
    }
}