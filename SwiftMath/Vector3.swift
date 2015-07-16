//
//  VectorMath.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 24/12/14.
//  Copyright (c) 2014 Matteo Battaglio. All rights reserved.
//

import Foundation

/// Vector in the three-dimensional Euclidean space – R×R×R
public struct Vector3<Real: RealType>: VectorType {
    
    public let x, y, z: Real
    
    public init(x: Real, y: Real, z: Real) {
        self.x = x
        self.y = y
        self.z = z
    }
    
//    public var squareLength: Real {
//        return self * self
//    }
//    
//    public var length: Real {
//        return norm
//    }
//    
//    public var norm: Real {
//        if x is Double {
//            return sqrt(squareLength as! Double) as! Real
//        } else {
//            return sqrtf(squareLength as! Float) as! Real
//        }
//    }
    
    public var components: (x: Real, y: Real, z: Real) {
        return (x, y, z)
    }
    
    public static func zero() -> Vector3 {
        return Vector3(x: 0.0, y: 0.0, z: 0.0)
    }
    
//    public func unit() -> Vector3<Real> {
//        return self / length
//    }
    
    public func rotate(rotation: Quaternion<Real>) -> Vector3 {
        assert(rotation.length == 1.0, "rotation is not a unit-length quaternion")
        return self + (rotation.im + rotation.im) × (rotation.im × self + rotation.re * self)
    }

}

// MARK: Hashable

extension Vector3 : Hashable {
 
    public var hashValue: Int {        
        if self.x is Double {
            return Int((x as! Double) + (y*10_000.0 as! Double) + (z*100_000_000.0 as! Double))
        } else {
            return Int((x as! Float) * (y*10_000.0 as! Float) * (z*100_000_000.0 as! Float))
        }
    }
    
}

public func == <Real: RealType>(lhs: Vector3<Real>, rhs: Vector3<Real>) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
}

// MARK: Operators

public func + <Real: RealType>(v1: Vector3<Real>, v2: Vector3<Real>) -> Vector3<Real> {
    return Vector3(x: v1.x + v2.x, y: v1.y + v2.y, z: v1.z + v2.z)
}

public func - <Real: RealType>(v1: Vector3<Real>, v2: Vector3<Real>) -> Vector3<Real> {
    return Vector3(x: v1.x - v2.x, y: v1.y - v2.y, z: v1.z - v2.z)
}

public prefix func - <Real: RealType>(vector: Vector3<Real>) -> Vector3<Real> {
    return Vector3(x: -vector.x, y: -vector.y, z: -vector.z)
}

public func * <Real: RealType>(scalar: Real, vector: Vector3<Real>) -> Vector3<Real> {
    return Vector3(x: vector.x * scalar, y: vector.y * scalar, z: vector.z * scalar)
    
}

public func / <Real: RealType>(vector: Vector3<Real>, scalar: Real) -> Vector3<Real> {
    return Vector3(x: vector.x / scalar, y: vector.y / scalar, z: vector.z / scalar)
}

public func dotProduct<Real: RealType>(v1: Vector3<Real>, v2: Vector3<Real>) -> Real {
    return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z)
}

/// Dot product
public func * <Real: RealType>(v1: Vector3<Real>, v2: Vector3<Real>) -> Real {
    return dotProduct(v1, v2: v2)
}

public func crossProduct<Real: RealType>(v1: Vector3<Real>, v2: Vector3<Real>) -> Vector3<Real> {
    let x = v1.y * v2.z - v1.z * v2.y
    let y = v1.z * v2.x - v1.x * v2.z
    let z = v1.x * v2.y - v1.y * v2.x
    
    return Vector3(x: x, y: y, z: z)
}

public func linearDependency<Real: RealType>(v1: Vector3<Real>, v2: Vector3<Real>) -> Real? {
    let a: Real? = (!v2.x.isZero) ? (v1.x / v2.x) : nil
    let b: Real? = (!v2.y.isZero) ? (v1.y / v2.y) : nil
    let c: Real? = (!v2.z.isZero) ? (v1.z / v2.z) : nil
    
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

extension Vector3: CustomStringConvertible {
    
    public var description: String {
        return "(x: \(x), y: \(y), z: \(z))"
    }
    
}