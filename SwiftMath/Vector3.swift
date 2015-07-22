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
    
    public var components: (x: Real, y: Real, z: Real) {
        return (x, y, z)
    }
    
    public static func zero() -> Vector3 {
        return Vector3(x: 0.0, y: 0.0, z: 0.0)
    }
    
    public func scale(value: Real) -> Vector3 {
        return Vector3(x: value * x, y: value * y, z: value * z)
    }
    
    public func dotProduct(vector: Vector3) -> Real {
        return (x * vector.x) + (y * vector.y) + (z * vector.z)
    }
    
    public func crossProduct(vector: Vector3) -> Vector3 {
        let cx = y * vector.z - z * vector.y
        let cy = z * vector.x - x * vector.z
        let cz = x * vector.y - y * vector.x
        
        return Vector3(x: cx, y: cy, z: cz)
    }
    
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
            return Int((x as! Float) + (y*10_000.0 as! Float) + (z*100_000_000.0 as! Float))
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

infix operator × { associativity left precedence 150 }
/// Cross product
public func × <Real: RealType>(v1: Vector3<Real>, v2: Vector3<Real>) -> Vector3<Real> {
    return v1.crossProduct(v2)
}

extension Vector3: CustomStringConvertible {
    
    public var description: String {
        return "(x: \(x), y: \(y), z: \(z))"
    }
    
}