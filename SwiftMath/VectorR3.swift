//
//  VectorMath.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 24/12/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

import Foundation

/// Vector in the three-dimensional Euclidean space – R×R×R
public struct VectorR3<T: RealType> {
    
    public let x, y, z: T
    
    public init(x: T, y: T, z: T) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public var squareLength: T {
        return self * self
    }
    
    public var length: T {
        return norm
    }
    
    public var norm: T {
        if x is Double {
            return sqrt(squareLength as! Double) as! T
        } else {
            return sqrtf(squareLength as! Float) as! T
        }
    }
    
    public var components: (x: T, y: T, z: T) {
        return (x, y, z)
    }
    
    public static func zero() -> VectorR3<T> {
        return VectorR3(x: T(0), y: T(0), z: T(0))
    }
    
    public func unit() -> VectorR3<T> {
        return self / length
    }

}

// MARK: Hashable

extension VectorR3 : Hashable {
 
    public var hashValue: Int {
        if self.x is Double {
            return Int((x as! Double) * (y as! Double) * (z as! Double))
        } else {
            return Int((x as! Float) * (y as! Float) * (z as! Float))
        }
    }
    
}

public func == <T: RealType>(lhs: VectorR3<T>, rhs: VectorR3<T>) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == lhs.y) && (lhs.z == lhs.z)
}

// MARK: Operators

public func + <T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> VectorR3<T> {
    return VectorR3(x: v1.x + v2.x, y: v1.y + v2.y, z: v1.z + v2.z)
}

public func - <T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> VectorR3<T> {
    return VectorR3(x: v1.x - v2.x, y: v1.y - v2.y, z: v1.z - v2.z)
}

public prefix func - <T: RealType>(vector: VectorR3<T>) -> VectorR3<T> {
    return VectorR3(x: 0.0 - vector.x, y: 0.0 - vector.y, z: 0.0 - vector.z)
}

public func * <T: RealType>(scalar: T, vector: VectorR3<T>) -> VectorR3<T> {
    return VectorR3(x: vector.x * scalar, y: vector.y * scalar, z: vector.z * scalar)
    
}

public func * <T: RealType>(vector: VectorR3<T>, scalar: T) -> VectorR3<T> {
    return scalar * vector
}

public func / <T: RealType>(vector: VectorR3<T>, scalar: T) -> VectorR3<T> {
    return VectorR3(x: vector.x / scalar, y: vector.y / scalar, z: vector.z / scalar)
}

public func dotProduct<T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> T {
    return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z)
}

/// Dot product
public func * <T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> T {
    return dotProduct(v1, v2)
}

public func crossProduct<T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> VectorR3<T> {
    let x = v1.y * v2.z - v1.z * v2.y
    let y = v1.z * v2.x - v1.x * v2.z
    let z = v1.x * v2.y - v1.y * v2.x
    
    return VectorR3(x: x, y: y, z: z)
}

infix operator × { associativity left precedence 150 }
/// Cross product
public func × <T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> VectorR3<T> {
    return crossProduct(v1, v2)
}

public func linearDependency<T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> T? {
    let a: T? = (!v2.x.isZero) ? (v1.x / v2.x) : nil
    let b: T? = (!v2.y.isZero) ? (v1.y / v2.y) : nil
    let c: T? = (!v2.z.isZero) ? (v1.z / v2.z) : nil
    
    switch (a, b, c) {
    case let (t, nil, nil):
        return (v1.y.isZero) && (v1.z.isZero) ? t : nil
    case let (nil, t, nil):
        return (v1.x.isZero) && (v1.z.isZero) ? t : nil
    case let (nil, nil, t):
        return (v1.x.isZero) && (v1.y.isZero) ? t : nil
    case let (t, u, nil) where t == u:
        return (v1.z.isZero) ? t : nil
    case let (t, nil, u) where t == u:
        return (v1.y.isZero) ? t : nil
    case let (nil, t, u) where t == u:
        return (v1.x.isZero) ? t : nil
    case let (t, u, v) where (t == u) && (t == v):
        return t
    default:
        return nil
    }
}

public func distance<T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> T {
    return (v1 - v2).length
}

public func squareDistance<T: RealType>(v1: VectorR3<T>, v2: VectorR3<T>) -> T {
    return (v1 - v2).squareLength
}
