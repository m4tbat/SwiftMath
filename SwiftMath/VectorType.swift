//
//  VectorType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 16/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public protocol VectorType {
    
    typealias Real: RealType
    
    var squareLength: Real { get }
    
    var length: Real { get }
    
    var norm: Real { get }
    
    static func zero() -> Self
    
    func unit() -> Self
        
    // MARK: Operators
    
    func +(v1: Self, v2: Self) -> Self
    
    func -(v1: Self, v2: Self) -> Self
    
    func *(scalar: Real, vector: Self) -> Self
    
    func /(vector: Self, scalar: Real) -> Self
    
    prefix func -(vector: Self) -> Self
    
    func scale(value: Real) -> Self
    
    func dotProduct(vector: Self) -> Real
    
    func squareDistanceTo(vector: Self) -> Real
    
}

extension VectorType {
    
    public var squareLength: Real {
        return self.dotProduct(self)
    }
    
    public var length: Real {
        return norm
    }
    
    public var norm: Real {
        return squareLength.sqrt()
    }
    
    public func unit() -> Self {
        return self / length
    }
    
    public func distanceTo(vector: Self) -> Real {
        return (self - vector).length
    }
    
    public func squareDistanceTo(vector: Self) -> Real {
        return (self - vector).squareLength
    }
    
}

// MARK: Operators

public func * <Vector: VectorType, Real: RealType where Vector.Real == Real>(scalar: Real, vector: Vector) -> Vector {
    return vector.scale(scalar)
}

public func * <Vector: VectorType, Real: RealType where Real == Vector.Real>(vector: Vector, scalar: Real) -> Vector {
    return scalar * vector
}

public func / <Vector: VectorType, Real: RealType where Vector.Real == Real>(vector: Vector, scalar: Real) -> Vector {
    return vector.scale(1.0/scalar)
}

/// Dot product
public func * <Vector: VectorType, Real: RealType where Vector.Real == Real>(v1: Vector, v2: Vector) -> Real {
    return v1.dotProduct(v2)
}
