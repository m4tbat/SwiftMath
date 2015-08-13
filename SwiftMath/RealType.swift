//
//  RealType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 19/04/15.
//  Copyright (c) 2015 Dan Kogai, Matteo Battaglio. All rights reserved.
//

import Foundation

public protocol RealType : FloatingPointType, Hashable, FloatLiteralConvertible, SignedNumberType {
    
    init(_ value: Double)
    init(_ value: Float)
    
    // Built-in operators
    
    prefix func + (_: Self) -> Self
    prefix func - (_: Self) -> Self
    func + (_: Self, _: Self) -> Self
    func - (_: Self, _: Self) -> Self
    func * (_: Self, _: Self) -> Self
    func / (_: Self, _: Self) -> Self
    func += (inout _: Self, _: Self)
    func -= (inout _: Self, _: Self)
    func *= (inout _: Self, _: Self)
    func /= (inout _: Self, _: Self)
    
    // Methodized functions for protocol's sake
    
    var abs: Self { get }
    static var epsilon: Self { get }
    func cos() -> Self
    func exp() -> Self
    func log() -> Self
    func sin() -> Self
    func sqrt() -> Self
    func hypot(_: Self) -> Self
    func atan2(_: Self) -> Self
    func pow(_: Self) -> Self
    
    // Constants
    
    static var PI: Self { get }
    static var π: Self { get }
    static var E: Self { get }
    static var e: Self { get }
    static var LN2: Self { get }
    static var LOG2E: Self { get }
    static var LN10: Self { get }
    static var LOG10E: Self { get }
    static var SQRT2: Self { get }
    static var SQRT1_2: Self { get }
}

// MARK: - Constants

extension RealType {
    public var abs: Self { return Swift.abs(self) }
    
    public static var PI: Self { return 3.14159265358979323846264338327950288419716939937510 }
    public static var π: Self { return PI }
    public static var E: Self { return 2.718281828459045235360287471352662497757247093699 }
    public static var e: Self { return E }
    public static var LN2: Self { return 0.6931471805599453094172321214581765680755001343602552 }
    public static var LOG2E: Self { return 1.0 / LN2 }
    public static var LN10: Self { return 2.3025850929940456840179914546843642076011014886287729 }
    public static var LOG10E: Self { return 1.0 / LN10 }
    public static var SQRT2: Self { return 1.4142135623730950488016887242096980785696718753769480 }
    public static var SQRT1_2: Self { return 1.0 / SQRT2 }
}

// MARK: - Double extension to conform to RealType

// Double is default since floating-point literals are Double by default
extension Double: RealType {
    
    public func cos() -> Double { return Foundation.cos(self) }
    public func exp() -> Double { return Foundation.exp(self) }
    public func log() -> Double { return Foundation.log(self) }
    public func sin() -> Double { return Foundation.sin(self) }
    public func sqrt() -> Double { return Foundation.sqrt(self) }
    public func atan2(y: Double) -> Double { return Foundation.atan2(self, y) }
    public func hypot(y: Double) -> Double { return Foundation.hypot(self, y) }
    public func pow(y: Double) -> Double { return Foundation.pow(self, y) }

    public static let epsilon = 0x1p-52
}

// MARK: - Float extension to conform to RealType

// But when explicitly typed you can use Float
extension Float: RealType {
    public func cos() -> Float { return Foundation.cos(self) }
    public func exp() -> Float { return Foundation.exp(self) }
    public func log() -> Float { return Foundation.log(self) }
    public func sin() -> Float { return Foundation.sin(self) }
    public func sqrt() -> Float { return Foundation.sqrt(self) }
    public func hypot(y: Float) -> Float { return Foundation.hypot(self, y) }
    public func atan2(y: Float) -> Float { return Foundation.atan2(self, y) }
    public func pow(y: Float) -> Float { return Foundation.pow(self, y) }

    public static let epsilon: Float = 0x1p-23
}

//
// approximate comparison
//
public func =~ <T: RealType>(lhs: T, rhs: T) -> Bool {
    if lhs == rhs {
        return true
    }
    return (rhs - lhs).abs < T.epsilon
//    let epsilon = sizeof(T) < 8 ? 0x1p-23 : 0x1p-52
//    return t.abs <= T(2) * T(epsilon)
}

public func !~ <T: RealType>(lhs: T, rhs: T) -> Bool {
    return !(lhs =~ rhs)
}
