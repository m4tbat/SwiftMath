//
//  Complex.swift
//  SwiftMath
//
//  Created by Dan Kogai on 6/12/14.
//  Copyright (c) 2014 Dan Kogai, Matteo Battaglio. All rights reserved.
//

import Foundation

extension Double {
    /// self * 1.0i
    public var i: Complex<Double> {
        return Complex<Double>(0.0, self)
    }
}

extension Float {
    /// self * 1.0i
    public var i: Complex<Float> {
        return Complex<Float>(0.0, self)
    }
}

public struct Complex<T: RealType> {
    
    public let (re, im): (T, T)
    
    public let isReal: Bool
    
    public init(_ re: T, _ im: T) {
        self.re = re
        self.im = im
        isReal = im =~ T(0)
    }
    
    public init() {
        self.init(T(0), T(0))
    }
    
    public init(abs: T, arg: T) {
        self.init(abs * arg.cos(), abs * arg.sin())
    }
    
    public static func id() -> Complex<T> {
        return Complex(1.0, 0.0)
    }
    
    public static func zero() -> Complex<T> {
        return Complex(0.0, 0.0)
    }
    
    public var isZero: Bool {
        return re.isZero && im.isZero
    }
    
    /// absolute value thereof
    public var abs: T {
        return re.hypot(im)
    }
    
    /// argument thereof
    public var arg: T {
        return im.atan2(re)
    }
    
    /// norm thereof
    public var norm: T {
        return re.hypot(im)
    }
    
    /// conjugate thereof
    public func conj() -> Complex<T> {
        return Complex(re, -im)
    }
    
    public func reciprocal() -> Complex<T> {
        let length = norm
        return conj() / (length * length)
    }
    
    /// projection thereof
    public func proj() -> Complex<T> {
        if re.isFinite && im.isFinite {
            return self
        } else {
            return Complex(T(1)/T(0), im.isSignMinus ? -T(0) : T(0))
        }
    }
    
    /// (real, imag)
    public var tuple: (T, T) {
        return (re, im)
    }
    
    /// z * i
    public var i: Complex<T> {
        return Complex(-im, re)
    }
    
    /// .hashvalue -- conforms to Hashable
    
}

extension Complex: Hashable {
    
    public var hashValue: Int { // take most significant halves and join
        let bits = sizeof(Int) * 4
        let mask = bits == 16 ? 0xffff : 0x7fffFFFF
        return (re.hashValue & ~mask) | (im.hashValue >> bits)
    }
    
}

public func == <T>(lhs: Complex<T>, rhs: Complex<T>) -> Bool {
    return lhs.re == rhs.re && lhs.im == rhs.im
}

public func == <T>(lhs: Complex<T>, rhs: T) -> Bool {
    return lhs.re == rhs && lhs.im.isZero
}

public func == <T>(lhs: T, rhs: Complex<T>) -> Bool {
    return rhs.re == lhs && rhs.im.isZero
}

extension Complex: CustomStringConvertible {
    
    public var description: String {
        let plus = im.isSignMinus ? "" : "+"
        return "(\(re)\(plus)\(im).i)"
    }
    
}

// operator definitions
infix operator ** { associativity right precedence 170 }
infix operator **= { associativity right precedence 90 }
infix operator =~ { associativity none precedence 130 }
infix operator !~ { associativity none precedence 130 }



// +, +=
public prefix func + <T>(z: Complex<T>) -> Complex<T> {
    return z
}

public func + <T>(lhs: Complex<T>, rhs: Complex<T>) -> Complex<T> {
    return Complex(lhs.re + rhs.re, lhs.im + rhs.im)
}

public func + <T>(lhs: Complex<T>, rhs: T) -> Complex<T> {
    return lhs + Complex(rhs, T(0))
}

public func + <T>(lhs: T, rhs: Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) + rhs
}

public func += <T>(inout lhs: Complex<T>, rhs: Complex<T>) {
    lhs = Complex(lhs.re + rhs.re, lhs.im + rhs.im)
}

public func += <T>(inout lhs: Complex<T>, rhs: T) {
    lhs = Complex(lhs.re + rhs, lhs.im)
}

// -, -=
public prefix func - <T>(z: Complex<T>) -> Complex<T> {
    return Complex<T>(-z.re, -z.im)
}

public func - <T>(lhs: Complex<T>, rhs: Complex<T>) -> Complex<T> {
    return Complex(lhs.re - rhs.re, lhs.im - rhs.im)
}

public func - <T>(lhs: Complex<T>, rhs: T) -> Complex<T> {
    return lhs - Complex(rhs, T(0))
}

public func - <T>(lhs: T, rhs: Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) - rhs
}

public func -= <T>(inout lhs: Complex<T>, rhs: Complex<T>) {
    lhs = Complex(lhs.re - rhs.re, lhs.im - rhs.im)
}

public func -= <T>(inout lhs: Complex<T>, rhs: T) {
    lhs = Complex(lhs.re - rhs, lhs.im)
}

// *, *=
public func * <T>(lhs: Complex<T>, rhs: Complex<T>) -> Complex<T> {
    return Complex(
        lhs.re * rhs.re - lhs.im * rhs.im,
        lhs.re * rhs.im + lhs.im * rhs.re
    )
}

public func * <T>(lhs: Complex<T>, rhs: T) -> Complex<T> {
    return Complex(lhs.re * rhs, lhs.im * rhs)
}

public func * <T>(lhs: T, rhs: Complex<T>) -> Complex<T> {
    return Complex(lhs * rhs.re, lhs * rhs.im)
}

public func *= <T>(inout lhs: Complex<T>, rhs: Complex<T>) {
    lhs = lhs * rhs
}

public func *= <T>(inout lhs: Complex<T>, rhs: T) {
    lhs = lhs * rhs
}

// /, /=
//
// cf. https://github.com/dankogai/swift-complex/issues/3
//
public func / <T>(lhs: Complex<T>, rhs: Complex<T>) -> Complex<T> {
    if rhs.re.abs >= rhs.im.abs {
        let r = rhs.im / rhs.re
        let d = rhs.re + rhs.im * r
        return Complex (
            (lhs.re + lhs.im * r) / d,
            (lhs.im - lhs.re * r) / d
        )
    } else {
        let r = rhs.re / rhs.im
        let d = rhs.re * r + rhs.im
        return Complex (
            (lhs.re * r + lhs.im) / d,
            (lhs.im * r - lhs.re) / d
        )
        
    }
}

public func / <T>(lhs: Complex<T>, rhs: T) -> Complex<T> {
    return Complex(lhs.re / rhs, lhs.im / rhs)
}

public func / <T>(lhs: T, rhs: Complex<T>) -> Complex<T> {
    return Complex(lhs, T(0)) / rhs
}

public func /= <T>(inout lhs: Complex<T>, rhs:Complex<T>) {
    lhs = lhs / rhs
}

public func /= <T>(inout lhs: Complex<T>, rhs: T) {
    lhs = lhs / rhs
}

// exp(z)
public func exp<T>(z: Complex<T>) -> Complex<T> {
    let abs = z.re.exp()
    let arg = z.im
    return Complex(abs * arg.cos(), abs * arg.sin())
}

// log(z)
public func log<T>(z: Complex<T>) -> Complex<T> {
    return Complex(z.abs.log(), z.arg)
}

// log10(z) -- just because C++ has it
public func log10<T: RealType>(z: Complex<T>) -> Complex<T> {
    return log(z) / T(log(10.0))
}

public func log10<T: RealType>(r: T) -> T {
    return r.log() / T(log(10.0))
}

// pow(b, x)
public func pow<T>(lhs: Complex<T>, _ rhs: Complex<T>) -> Complex<T> {
    if rhs.isZero {
        return Complex(T(1), T(0)) // x ** 0 == 1
    } else if lhs.isZero && rhs.isReal && rhs.re > T(0) {
        return Complex.zero() // 0 ** x == 0 (when x > 0)
    } else if lhs.isReal && lhs.re > T(0) { // b^z == e^(z*ln(b)) (when b is a positive real number)
        let z = log(lhs) * rhs
        return exp(z)
    } else {
        // FIXME: Implement general case of complex powers of complex numbers the right way
        let z = log(lhs) * rhs
        return exp(z)
    }
}

public func pow<T>(lhs: Complex<T>, _ rhs: T) -> Complex<T> {
    return pow(lhs, Complex(rhs, T(0)))
}

public func pow<T>(lhs:T, _ rhs: Complex<T>) -> Complex<T> {
    return pow(Complex(lhs, T(0)), rhs)
}

// **, **=
public func ** <T: RealType>(lhs: T, rhs: T) -> T {
    return lhs.pow(rhs)
}

public func ** <T>(lhs: Complex<T>, rhs: Complex<T>) -> Complex<T> {
    return pow(lhs, rhs)
}

public func ** <T>(lhs: T, rhs: Complex<T>) -> Complex<T> {
    return pow(lhs, rhs)
}

public func ** <T>(lhs: Complex<T>, rhs: T) -> Complex<T> {
    return pow(lhs, rhs)
}

public func **= <T: RealType>(inout lhs: T, rhs: T) {
    lhs = lhs.pow(rhs)
}

public func **= <T>(inout lhs: Complex<T>, rhs: Complex<T>) {
    lhs = pow(lhs, rhs)
}

public func **= <T>(inout lhs: Complex<T>, rhs: T) {
    lhs = pow(lhs, rhs)
}

// sqrt(z)
public func sqrt<T>(z: Complex<T>) -> Complex<T> {
    // return z ** 0.5
    if z.isReal && z.re >= 0.0 {
        return Complex(z.re.sqrt(), 0.0)
    }
    
    let d = z.abs
    let re = ((z.re + d)/T(2)).sqrt()
    if z.im < T(0) {
        return Complex(re, -((-z.re + d)/T(2)).sqrt())
    } else {
        return Complex(re,  ((-z.re + d)/T(2)).sqrt())
    }
}

// cos(z)
public func cos<T>(z: Complex<T>) -> Complex<T> {
    return (exp(z.i) + exp(-z.i)) / T(2)
}

// sin(z)
public func sin<T>(z:Complex<T>) -> Complex<T> {
    return -(exp(z.i) - exp(-z.i)).i / T(2)
}

// tan(z)
public func tan<T>(z: Complex<T>) -> Complex<T> {
    let ezi = exp(z.i), e_zi = exp(-z.i)
    return (ezi - e_zi) / (ezi + e_zi).i
}

// atan(z)
public func atan<T>(z: Complex<T>) -> Complex<T> {
    let l0 = log(T(1) - z.i), l1 = log(T(1) + z.i)
    return (l0 - l1).i / T(2)
}

public func atan<T:RealType>(r: T) -> T {
    return atan(Complex(r, T(0))).re
}

// atan2(z, zz)
func atan2<T>(z: Complex<T>, zz: Complex<T>) -> Complex<T> {
    return atan(z / zz)
}

// asin(z)
public func asin<T>(z: Complex<T>) -> Complex<T> {
    return -log(z.i + sqrt(T(1) - z*z)).i
}

// acos(z)
public func acos<T>(z: Complex<T>) -> Complex<T> {
    return log(z - sqrt(T(1) - z*z).i).i
}

// sinh(z)
public func sinh<T>(z: Complex<T>) -> Complex<T> {
    return (exp(z) - exp(-z)) / T(2)
}

// cosh(z)
public func cosh<T>(z: Complex<T>) -> Complex<T> {
    return (exp(z) + exp(-z)) / T(2)
}

// tanh(z)
public func tanh<T>(z: Complex<T>) -> Complex<T> {
    let ez = exp(z), e_z = exp(-z)
    return (ez - e_z) / (ez + e_z)
}

// asinh(z)
public func asinh<T>(z: Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z + T(1)))
}

// acosh(z)
public func acosh<T>(z: Complex<T>) -> Complex<T> {
    return log(z + sqrt(z*z - T(1)))
}

// atanh(z)
public func atanh<T>(z: Complex<T>) -> Complex<T> {
    let t = log((1.0 + z)/(1.0 - z))
    return t / 2.0
}

// for the compatibility's sake w/ C++11
public func abs<T>(z: Complex<T>) -> T { return z.abs }
public func arg<T>(z: Complex<T>) -> T { return z.arg }
public func real<T>(z: Complex<T>) -> T { return z.re }
public func imag<T>(z: Complex<T>) -> T { return z.im }
public func norm<T>(z: Complex<T>) -> T { return z.norm }
public func conj<T>(z: Complex<T>) -> Complex<T> { return z.conj() }
public func proj<T>(z: Complex<T>) -> Complex<T> { return z.proj() }

//
// approximate comparisons
//
public func =~ <T>(lhs: Complex<T>, rhs: Complex<T>) -> Bool {
    if lhs == rhs {
        return true
    }
    return lhs.abs =~ rhs.abs
}

public func =~ <T>(lhs: Complex<T>, rhs: T) -> Bool {
    return lhs.abs =~ rhs.abs
}

public func =~ <T>(lhs: T, rhs: Complex<T>) -> Bool {
    return lhs.abs =~ rhs.abs
}

public func !~ <T>(lhs: Complex<T>, rhs: Complex<T>) -> Bool {
    return !(lhs =~ rhs)
}

func !~ <T>(lhs: Complex<T>, rhs: T) -> Bool {
    return !(lhs =~ rhs)
}

func !~ <T>(lhs: T, rhs: Complex<T>) -> Bool {
    return !(lhs =~ rhs)
}

// typealiases
typealias Complex64 = Complex<Double>
typealias Complex32 = Complex<Float>
