//
//  VectorType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 16/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public protocol VectorType {
    
    typealias Real = RealType
    
    var squareLength: Real { get }
    
    var length: Real { get }
    
    var norm: Real { get }
    
    static func zero() -> Self
    
    func unit() -> Self
    
    func rotate<T: RealType where T == Real>(rotation: Quaternion<T>) -> Self
    
    // MARK: Operators
    
    func +(v1: Self, v2: Self) -> Self
    
    func -(v1: Self, v2: Self) -> Self
    
    prefix func -(vector: Self) -> Self
    
    func *(scalar: Real, vector: Self) -> Self
    
    func *(vector: Self, scalar: Real) -> Self
    
    func /(vector: Self, scalar: Real) -> Self
    
    func dotProductWith(vector: Self) -> Real
    
    /// Dot product
    func *(v1: Self, v2: Self) -> Real
    
    func crossProductWith(vector: Self) -> Self
    
    /// Cross product
    func ×(v1: Self, v2: Self) -> Self
    
    func linearDependency(v1: Self, v2: Self) -> Real?
    
    func distanceFrom(vector: Self) -> Real
    
    func squareDistanceFrom(vector: Self) -> Real
    
}

extension VectorType {
    
    public var squareLength: Real {
        return self * self
    }
    
    public var length: Real {
        return norm
    }
    
    public var norm: Real {
        if Real.self is Double {
            return sqrt(squareLength as! Double) as! Real
        } else {
            return sqrtf(squareLength as! Float) as! Real
        }
    }
    
    public func unit() -> Self {
        return self / length
    }
    
    public func distanceFrom(vector: Self) -> Real {
        return (self - vector).length
    }
    
    public func squareDistanceFrom(vector: Self) -> Real {
        return (self - vector).squareLength
    }
    
}

// MARK: Operators

public func * <Vector: VectorType, Real: RealType where Real == Vector.Real>(vector: Vector, scalar: Real) -> Vector {
    return scalar * vector
}

infix operator × { associativity left precedence 150 }
/// Cross product
public func × <Vector: VectorType>(v1: Vector, v2: Vector) -> Vector {
    return v1.crossProductWith(v2)
}
