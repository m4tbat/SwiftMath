//
//  Quaternions.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 21/03/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public struct Quaternion<T: RealType> : Equatable {
    
    public let re: T
    public let im: Vector3<T>
    
    public let isReal: Bool
    
    public init(_ re: T, _ im: Vector3<T>) {
        self.re = re
        self.im = im
        isReal = im == Vector3.zero()
    }
    
    public init(axis: Vector3<T>, angle: T) {
        assert(axis.length == 1.0, "axis is not a unit-length vector")
        let halfAngle = angle/2.0
        self.init(halfAngle.cos(), axis * halfAngle.sin())
    }
    
    public static func id() -> Quaternion<T> {
        return Quaternion(1.0, .zero())
    }
    
    public var squareLength: T {
        return re * re + im * im
    }
    
    public var length: T {
        return norm
    }
    
    public var norm: T {
        if re is Double {
            return sqrt(squareLength as! Double) as! T
        } else {
            return sqrtf(squareLength as! Float) as! T
        }
    }
    
    public func unit() -> Quaternion<T> {
        return self / length
    }
    
    public func conj() -> Quaternion<T> {
        return Quaternion(re, -im)
    }
    
    public func reciprocal() -> Quaternion<T> {
        return self.conj() / squareLength
    }
    
}

public func == <T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Bool {
    return lhs.re == rhs.re && lhs.im == rhs.im
}

public func + <T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Quaternion<T> {
    return Quaternion(lhs.re + rhs.re, lhs.im + rhs.im)
}

public func - <T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Quaternion<T> {
    return Quaternion(lhs.re - rhs.re, lhs.im - rhs.im)
}

public func * <T: RealType>(lhs: T, rhs: Quaternion<T>) -> Quaternion<T> {
    return Quaternion(rhs.re * lhs, rhs.im * lhs)
}

public func * <T: RealType>(lhs: Quaternion<T>, rhs: T) -> Quaternion<T> {
    return rhs * lhs
}

public func / <T: RealType>(quaternion: Quaternion<T>, scalar: T) -> Quaternion<T> {
    return 1.0/scalar * quaternion
}

/// Dot product
public func dotProduct<T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> T {
    return lhs.re * rhs.re + lhs.im * rhs.im
}

/// Dot product
public func * <T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> T {
    return dotProduct(lhs, rhs: rhs)
}

public func multiply<T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Quaternion<T> {
    let re = lhs.re * rhs.re - lhs.im * rhs.im
    let im = lhs.re * rhs.im + rhs.re * lhs.im + lhs.im × rhs.im
    return Quaternion(re, im)
}

infix operator × { associativity left precedence 150 }
/// Multiplication
public func × <T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Quaternion<T> {
    return multiply(lhs, rhs: rhs)
}

extension Quaternion: CustomStringConvertible {
    
    public var description: String {
        return "(re: \(re), im: \(im))"
    }
    
}
