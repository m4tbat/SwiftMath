//
//  Vector2.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 16/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

/// Vector in the two-dimensional Euclidean space – R×R
public struct Vector2<Real: RealType>: VectorType {

    public let x, y: Real
    
    public init(_ coordinates: [Real]) {
        if coordinates.count != 2 {
            fatalError("Vector2 must be initialized with an array of 2 values")
        }
        self.init(x: coordinates[0], y: coordinates[1])
    }
    
    public init(x: Real, y: Real) {
        self.x = x
        self.y = y
    }
    
    public var coordinates: [Real] {
        return [x, y]
    }
    
    public var components: (x: Real, y: Real) {
        return (x, y)
    }
    
    public static func zero() -> Vector2 {
        return Vector2(x: 0.0, y: 0.0)
    }
    
    public func scale(value: Real) -> Vector2 {
        return Vector2(x: value * x, y: value * y)
    }
    
    public func dotProduct(vector: Vector2) -> Real {
        return (x * vector.x) + (y * vector.y)
    }
    
}

// MARK: Hashable

extension Vector2 : Equatable, Hashable {
    
    public var hashValue: Int {
        if self.x is Double {
            return Int((x as! Double) + (y*10_000.0 as! Double))
        } else {
            return Int((x as! Float) + (y*10_000.0 as! Float))
        }
    }
    
}

public func == <Real: RealType>(lhs: Vector2<Real>, rhs: Vector2<Real>) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y)
}

// MARK: Operators

public func + <Real: RealType>(v1: Vector2<Real>, v2: Vector2<Real>) -> Vector2<Real> {
    return Vector2(x: v1.x + v2.x, y: v1.y + v2.y)
}

public func - <Real: RealType>(v1: Vector2<Real>, v2: Vector2<Real>) -> Vector2<Real> {
    return Vector2(x: v1.x - v2.x, y: v1.y - v2.y)
}

public prefix func - <Real: RealType>(vector: Vector2<Real>) -> Vector2<Real> {
    return Vector2(x: -vector.x, y: -vector.y)
}