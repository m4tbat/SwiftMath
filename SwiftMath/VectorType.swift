//
//  VectorType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 16/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public protocol VectorType: Equatable, ArrayLiteralConvertible {
    
    typealias Real: RealType
    
    init(_ coordinates: [Real])
    
    init(_ coordinates: Real...)
    
    static func zero(dimension: Int) -> Self
    
    var coordinates: [Real] { get }
    
    var squareLength: Real { get }
    
    var length: Real { get }
    
    var norm: Real { get }
    
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
    
    public init(_ elements: Real...) {
        self.init(elements)
    }
    
    public init(arrayLiteral elements: Real...) {
        self.init(elements)
    }
    
    public static func zero(dimension: Int) -> Self {
        return Self(Array(count: dimension, repeatedValue: 0.0))
    }
    
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
    
    public func scale(value: Real) -> Self {
        return Self(coordinates.map { $0 * value })
    }
    
    public func dotProduct(vector: Self) -> Real {
        var i = 0
        return coordinates.reduce(Real(0)) { (sumOfProducts, coordinate) in
            sumOfProducts + coordinate*vector.coordinates[i++]
        }
    }
    
    public func distanceTo(vector: Self) -> Real {
        return (self - vector).length
    }
    
    public func squareDistanceTo(vector: Self) -> Real {
        return (self - vector).squareLength
    }
    
}

// MARK: Equatable

public func == <Vector: VectorType>(lhs: Vector, rhs: Vector) -> Bool {
    return lhs.coordinates == rhs.coordinates
}

// MARK: Operators

public func + <Vector: VectorType>(v1: Vector, v2: Vector) -> Vector {
    return zipAndCombine(v1, v2, +)
}

public prefix func - <Vector: VectorType>(vector: Vector) -> Vector {
    return Vector(vector.coordinates.map(-))
}

public func - <Vector: VectorType>(v1: Vector, v2: Vector) -> Vector {
    return zipAndCombine(v1, v2, -)
}

public func * <Vector: VectorType>(scalar: Vector.Real, vector: Vector) -> Vector {
    return vector.scale(scalar)
}

public func * <Vector: VectorType>(vector: Vector, scalar: Vector.Real) -> Vector {
    return scalar * vector
}

public func / <Vector: VectorType>(vector: Vector, scalar: Vector.Real) -> Vector {
    return vector.scale(1.0/scalar)
}

/// Dot product
public func * <Vector: VectorType>(v1: Vector, v2: Vector) -> Vector.Real {
    return v1.dotProduct(v2)
}

// MARK: Private functions

private func zipAndCombine<Vector: VectorType>(v1: Vector, _ v2: Vector, _ op: (Vector.Real, Vector.Real) -> Vector.Real) -> Vector {
    return Vector(zip(v1.coordinates, v2.coordinates).map { (c1, c2) in op(c1, c2) })
}
