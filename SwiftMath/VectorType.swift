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
    
    func * <Real: RealType>(scalar: Real, vector: Self) -> Self
    
    func * <Real: RealType>(vector: Self, scalar: Real) -> Self
    
    func / <Real: RealType>(vector: Self, scalar: Real) -> Self
    
    func dotProduct<Real: RealType>(v1: Self, v2: Self) -> Real
    
    /// Dot product
    func *(v1: Self, v2: Self) -> Real
    
    func crossProduct(v1: Self, v2: Self) -> Self
    
    /// Cross product
    func ×(v1: Self, v2: Self) -> Self
    
    func linearDependency<Real: RealType>(v1: Self, v2: Self) -> Real?
    
    func distance<Real: RealType>(v1: Self, v2: Self) -> Real
    
    func squareDistance<Real: RealType>(v1: Self, v2: Self) -> Real
    
}

infix operator × { associativity left precedence 150 }

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
    
}