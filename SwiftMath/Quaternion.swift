//
//  Quaternions.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 21/03/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public struct Quaternion<Real: RealType> : Equatable {
    
    public let re: Real
    public let im: Vector3<Real>
    
    public let isReal: Bool
    
    public init(_ re: Real, _ im: Vector3<Real>) {
        self.re = re
        self.im = im
        isReal = im == Vector3.zero()
    }
    
    public init(axis: Vector3<Real>, angle: Real) {
        assert(axis.length == 1.0, "axis is not a unit-length vector")
        let halfAngle = angle/2.0
        self.init(halfAngle.cos(), axis * halfAngle.sin())
    }
    
    public static func id() -> Quaternion<Real> {
        return Quaternion(1.0, .zero())
    }
    
    public var squareLength: Real {
        return re * re + im * im
    }
    
    public var length: Real {
        return norm
    }
    
    public var norm: Real {
        return squareLength.sqrt()
    }
    
    public func unit() -> Quaternion<Real> {
        return self / length
    }
    
    public func conj() -> Quaternion<Real> {
        return Quaternion(re, -im)
    }
    
    public func reciprocal() -> Quaternion<Real> {
        return self.conj() / squareLength
    }
    
}

public func == <Real: RealType>(lhs: Quaternion<Real>, rhs: Quaternion<Real>) -> Bool {
    return lhs.re == rhs.re && lhs.im == rhs.im
}

public func + <Real: RealType>(lhs: Quaternion<Real>, rhs: Quaternion<Real>) -> Quaternion<Real> {
    return Quaternion(lhs.re + rhs.re, lhs.im + rhs.im)
}

public func - <Real: RealType>(lhs: Quaternion<Real>, rhs: Quaternion<Real>) -> Quaternion<Real> {
    return Quaternion(lhs.re - rhs.re, lhs.im - rhs.im)
}

public func * <Real: RealType>(lhs: Real, rhs: Quaternion<Real>) -> Quaternion<Real> {
    return Quaternion(rhs.re * lhs, rhs.im * lhs)
}

public func * <Real: RealType>(lhs: Quaternion<Real>, rhs: Real) -> Quaternion<Real> {
    return rhs * lhs
}

public func / <Real: RealType>(quaternion: Quaternion<Real>, scalar: Real) -> Quaternion<Real> {
    return 1.0/scalar * quaternion
}

/// Dot product
public func dotProduct<Real: RealType>(lhs: Quaternion<Real>, rhs: Quaternion<Real>) -> Real {
    return lhs.re * rhs.re + lhs.im * rhs.im
}

/// Dot product
public func * <Real: RealType>(lhs: Quaternion<Real>, rhs: Quaternion<Real>) -> Real {
    return dotProduct(lhs, rhs: rhs)
}

public func multiply<Real: RealType>(lhs: Quaternion<Real>, rhs: Quaternion<Real>) -> Quaternion<Real> {
    let re = lhs.re * rhs.re - lhs.im * rhs.im
    let im = lhs.re * rhs.im + rhs.re * lhs.im + lhs.im × rhs.im
    return Quaternion(re, im)
}

infix operator × { associativity left precedence 150 }
/// Multiplication
public func × <Real: RealType>(lhs: Quaternion<Real>, rhs: Quaternion<Real>) -> Quaternion<Real> {
    return multiply(lhs, rhs: rhs)
}

extension Quaternion: CustomStringConvertible {
    
    public var description: String {
        return "(re: \(re), im: \(im))"
    }
    
}
