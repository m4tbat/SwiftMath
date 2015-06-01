//
//  RealType.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 19/04/15.
//  Copyright (c) 2015 Dan Kogai, Matteo Battaglio. All rights reserved.
//

import Foundation

public protocol RealType : FloatingPointType, Hashable, FloatLiteralConvertible {
    init(_ value: Double)
    init(_ value: Float)
    // Built-in operators
    prefix func + (Self) -> Self
    prefix func - (Self) -> Self
    func + (Self, Self) -> Self
    func - (Self, Self) -> Self
    func * (Self, Self) -> Self
    func / (Self, Self) -> Self
    func += (inout Self, Self)
    func -= (inout Self, Self)
    func *= (inout Self, Self)
    func /= (inout Self, Self)
    // methodized functions for protocol's sake
    var abs: Self { get }
    static var epsilon: Self { get }
    func cos() -> Self
    func exp() -> Self
    func log() -> Self
    func sin() -> Self
    func sqrt() -> Self
    func hypot(Self) -> Self
    func atan2(Self) -> Self
    func pow(Self) -> Self
}

struct RealConstants {
    static let PI = 3.14159265358979323846264338327950288419716939937510
    static let π = PI
    static let E =  2.718281828459045235360287471352662497757247093699
    static let e = E
    static let LN2 =
    0.6931471805599453094172321214581765680755001343602552
    static let LOG2E = 1 / LN2
    static let LN10 =
    2.3025850929940456840179914546843642076011014886287729
    static let LOG10E = 1/LN10
    static let SQRT2 =
    1.4142135623730950488016887242096980785696718753769480
    static let SQRT1_2 = 1/SQRT2
    static let epsilon = 0x1p-52
}

// Double is default since floating-point literals are Double by default
extension Double : RealType {
    public var abs: Double { return Swift.abs(self) }
    public func cos() -> Double { return Foundation.cos(self) }
    public func exp() -> Double { return Foundation.exp(self) }
    public func log() -> Double { return Foundation.log(self) }
    public func sin() -> Double { return Foundation.sin(self) }
    public func sqrt() -> Double { return Foundation.sqrt(self) }
    public func atan2(y: Double) -> Double { return Foundation.atan2(self, y) }
    public func hypot(y: Double) -> Double { return Foundation.hypot(self, y) }
    public func pow(y: Double) -> Double { return Foundation.pow(self, y) }
    
    public static let PI = RealConstants.PI
    public static let π = PI
    public static let E = RealConstants.E
    public static let e = E
    public static let LN2 = RealConstants.LN2
    public static let LOG2E = RealConstants.LOG2E
    public static let LN10 = RealConstants.LN10
    public static let LOG10E = 1/LN10
    public static let SQRT2 = RealConstants.SQRT2
    public static let SQRT1_2 = RealConstants.SQRT1_2
    public static let epsilon = 0x1p-52
}

// But when explicitly typed you can use Float
extension Float : RealType {
    public var abs: Float { return Swift.abs(self) }
    public func cos() -> Float { return Foundation.cos(self) }
    public func exp() -> Float { return Foundation.exp(self) }
    public func log() -> Float { return Foundation.log(self) }
    public func sin() -> Float { return Foundation.sin(self) }
    public func sqrt() -> Float { return Foundation.sqrt(self) }
    public func hypot(y: Float) -> Float { return Foundation.hypot(self, y) }
    public func atan2(y: Float) -> Float { return Foundation.atan2(self, y) }
    public func pow(y: Float) -> Float { return Foundation.pow(self, y) }
    
    public static let PI = RealConstants.PI
    public static let π = PI
    public static let E = RealConstants.E
    public static let e = E
    public static let LN2 = RealConstants.LN2
    public static let LOG2E = RealConstants.LOG2E
    public static let LN10 = RealConstants.LN10
    public static let LOG10E = 1/LN10
    public static let SQRT2 = RealConstants.SQRT2
    public static let SQRT1_2 = RealConstants.SQRT1_2
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
