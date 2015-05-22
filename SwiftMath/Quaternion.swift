//
//  Quaternions.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 21/03/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public struct Quaternion<T: RealType> : Equatable {
    let re: T
    let im: VectorR3<T>
    
    public init(re: T, im: VectorR3<T>) {
        self.re = re
        self.im = im
    }
    
    public init(axis: VectorR3<T>, angle: T) {
        assert(axis.length == 1.0, "axis is not a unit-length vector")
        let halfAngle = angle/2.0
        self.init(re: halfAngle.cos(), im: axis * halfAngle.sin())
    }
    
    public static func id() -> Quaternion<T> {
        return Quaternion(re: 1.0, im: .id())
    }
    
    public var squareLength: T {
        return re * re + im * im
    }
    
    public var length: T {
        return euclideanNorm
    }
    
    public var euclideanNorm: T {
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
        return Quaternion(re: re, im: -im)
    }
    
    public func reciprocal() -> Quaternion<T> {
        return self.conj() / squareLength
    }
    
}

public func == <T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Bool {
    return lhs.re == rhs.re && lhs.im == rhs.im
}

public func + <T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Quaternion<T> {
    return Quaternion(re: lhs.re + rhs.re, im: lhs.im + rhs.im)
}

public func * <T: RealType>(lhs: T, rhs: Quaternion<T>) -> Quaternion<T> {
    return Quaternion(re: rhs.re * lhs, im: rhs.im * lhs)
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
    return dotProduct(lhs, rhs)
}

public func multiply<T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Quaternion<T> {
    let re = lhs.re * rhs.re - lhs.im * rhs.im
    let im = lhs.re * rhs.im + rhs.re * lhs.im + lhs.im × rhs.im
    return Quaternion(re: re, im: im)
}

infix operator × { associativity left precedence 150 }
/// Multiplication
public func × <T: RealType>(lhs: Quaternion<T>, rhs: Quaternion<T>) -> Quaternion<T> {
    return multiply(lhs, rhs)
}

extension VectorR3 {
    
    public func rotate(rotation: Quaternion<T>) -> VectorR3<T> {
        assert(rotation.length == 1.0, "rotation is not a unit-length quaternion")
        return self + (rotation.im + rotation.im) × (rotation.im × self + rotation.re * self)
    }
    
}
