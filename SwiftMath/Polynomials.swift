//
//  Polinomials.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 08/01/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation
import Set

public func linear<Real: RealType>(a: Real, b: Real) -> Multiset<Complex<Real>> {
    if a.isZero {
        return []
    }
    
    let x = -b/a
    return [Complex(x, 0.0)]
}

public func quadratic<Real: RealType>(a: Real, b: Real, c: Real) -> Multiset<Complex<Real>> {
    if a.isZero {
        return linear(b, c)
    }
    
    if c.isZero {
        return [Complex.zero()] + linear(a, b)
    }
    
    let discriminant = (b * b) - (4.0 * a * c)
    var dSqrt = sqrt(Complex(discriminant, 0.0))
    if b.isSignMinus {
        dSqrt = -dSqrt
    }
    let x1 = -(b + dSqrt) / (2.0 * a)
    let x2 = c / (a * x1)
    
    return [x1, x2]
}

public func cubic<Real: RealType>(a: Real, var b: Real, var c: Real, var d: Real) -> Multiset<Complex<Real>> {
    if a.isZero {
        return quadratic(b, c, d)
    }
    
    if d.isZero {
        return [Complex.zero()] + quadratic(a, b, c)
    }
    
    if a != Real(1) {
        b /= a
        c /= a
        d /= a
    }
    
    let b2 = b*b
    let b3 = b2*b
    
    let D0 = b2 - (3.0 * c)
    let bc9 = 9.0 * b * c
    let D1 = (2.0 * b3) - bc9 + (27.0 * d)
    let minus27D = (D1 * D1) - (4.0 * D0 * D0 * D0)
    var squareRoot = sqrt(Complex(minus27D, 0.0))
    let oneThird: Real = 1.0/3.0
    let zero: Real = 0.0
    
    switch (D0.isZero, minus27D.isZero) {
    case (true, true):
        let x = Complex(-oneThird * b, zero)
        return [x, x, x]
    case (false, true):
        let d9 = 9.0 * d
        let bc4 = 4.0 * b * c
        let x12 = Complex((d9 - b * c) / (2.0 * D0), zero)
        let x3 = Complex((bc4 - d9 - b3) / D0, zero)
        return [x12, x12, x3]
    case (true, false):
        if (D1 + squareRoot) == zero {
            squareRoot = -squareRoot
        }
        fallthrough
    default:
        let C = pow(0.5 * (D1 + squareRoot), oneThird)
        
        let im: Complex<Real> = Complex(0.0, Real(0.5*sqrt(3.0)))
        let u2 = Real(-0.5) + im
        let u3 = Real(-0.5) - im
        let u2C = u2 * C
        let u3C = u3 * C
        
        let x1 = -oneThird * (b + C + (D0 / C))
        let x2 = -oneThird * (b + u2C + (D0 / u2C))
        let x3 = -oneThird * (b + u3C + (D0 / u3C))
        
        return [x1, x2, x3]
    }
}

public func quartic<Real: RealType>(var a: Real, var b: Real, var c: Real, var d: Real, var e: Real) -> Multiset<Complex<Real>> {
    if a.isZero {
        return cubic(b, c, d, e)
    }
    
    if e.isZero {
        return [Complex.zero()] + cubic(a, b, c, d)
    }
    
    if b.isZero && d.isZero { // Biquadratic
        let squares = quadratic(a, c, e)
        
//        var roots: Multiset<Complex<Real>> = []
//        for square in squares {
//            let x = sqrt(square)
//            roots.insert(x)
//            roots.insert(-x)
//        }
        
        return squares.flatMap { (square: Complex<Real>) -> Multiset<Complex<Real>> in
            let x = sqrt(square)
            return [x, -x]
        }
        
//        let x1 = sqrt(squares[0])
//        let x2 = sqrt(squares[1])
//        
//        return [x1, -x1, x2, -x2]
    }
    
    // Lodovico Ferrari's solution
    
    // Converting to a depressed quartic
    let a1 = b/a
    b = c/a
    c = d/a
    d = e/a
    a = a1
    
    let a2 = a*a
    let minus3a2 = -3.0*a2
    let ac64 = 64.0*a*c
    let a2b16 = 16.0*a2*b
    let aOn4 = a/4.0
    
    let p = b + minus3a2/8.0
    let q = (a2*a - 4.0*a*b)/8.0 + c
    let r = (minus3a2*a2 - ac64 + a2b16)/256.0 + d
    
    // Depressed quartic: u^4 + p*u^2 + q*u + r = 0
    
    if q.isZero { // Depressed quartic is biquadratic
        let squares = quadratic(1.0, p, r)
        
        return squares.flatMap { (square: Complex<Real>) -> Multiset<Complex<Real>> in
            let x = sqrt(square)
            return [x - aOn4, -x - aOn4]
        }
        
//        let x1 = sqrt(squares[0])
//        let x2 = sqrt(squares[1])
//        
//        return [
//            x1 - aOn4,
//            -x1 - aOn4,
//            x2 - aOn4,
//            -x2 - aOn4
//        ]
    }
    
    let p2 = p*p
    let q2On8 = q*q/8.0
    
    let cb = 2.5*p
    let cc = 2.0*p2 - r
    let cd = 0.5*p*(p2-r) - q2On8
    let yRoots = cubic(1.0, cb, cc, cd)
    
    let y = yRoots[yRoots.startIndex]
    let y2 = 2.0*y
    let sqrtPPlus2y = sqrt(p + y2)
    precondition(sqrtPPlus2y.isZero == false, "Failed to properly handle the case of the depressed quartic being biquadratic")
    let pPlusY = p + y
    let lastPart = 0.5*q/sqrtPPlus2y
    let p3 = 3.0*p
    let q2 = 2.0*q
    let fraction = q2/sqrtPPlus2y
    let p3Plus2y = p3 + y2
    let u1 = 0.5*(sqrtPPlus2y + sqrt(-(p3Plus2y + fraction)))
    let u2 = 0.5*(-sqrtPPlus2y + sqrt(-(p3Plus2y - fraction)))
    let u3 = 0.5*(sqrtPPlus2y - sqrt(-(p3Plus2y + fraction)))
    let u4 = 0.5*(-sqrtPPlus2y - sqrt(-(p3Plus2y - fraction)))
    return [
        u1 - aOn4,
        u2 - aOn4,
        u3 - aOn4,
        u4 - aOn4
    ]
}

/// Finds the roots of the polinomial whose coefficients are the passed arguments.
/// The grade of the polinomial is equal to the number of arguments minus one (coefficients.count - 1).
/// E.g. invoking polynomial(1, 2, 3, 4) (grade 3) will compute the (three) roots of: x^3 + 2x^2 + 3x + 4 = 0
public func polynomial<Real: RealType>(preferClosedFormSolution: Bool = true, coefficients: [Real]) -> Multiset<Complex<Real>> {
    switch (coefficients.count, preferClosedFormSolution) {
    case (0, true):
        preconditionFailure("the zero polynomial is undefined")
    case (1, true):
        if coefficients[0].isZero {
            preconditionFailure("the zero polynomial is undefined")
        }
        return []
    case (2, true):
        return linear(coefficients[0], coefficients[1])
    case (3, true):
        return quadratic(coefficients[0], coefficients[1], coefficients[2])
    case (4, true):
        return cubic(coefficients[0], coefficients[1], coefficients[2], coefficients[3])
    case (5, true):
        return quartic(coefficients[0], coefficients[1], coefficients[2], coefficients[3], coefficients[4])
    default:
        return polynomial(coefficients.map { Complex($0, Real(0)) })
    }
}

/// This implementation uses the Durand-Kerner-Weierstrass method to find the roots of a polynomial with complex coefficients.
public func polynomial<Real: RealType>(var coefficients: [Complex<Real>]) -> Multiset<Complex<Real>> {
    let one = Complex(Real(1), Real(0))
    
    if coefficients[0] != one {
        coefficients = coefficients.map { coefficient in
            coefficient / coefficients[0]
        }
    }
    
    var a0 = [one]
    for i in 1..<coefficients.count-1 {
        a0.append(a0.last! * Complex(Real(0.4), Real(0.9)))
    }
    
    var count = 0
    while count++ < 1000 {
        var roots: [Complex<Real>] = []
        for var i = 0; i < a0.count; i++ {
            var result = one
            for var j = 0; j < a0.count; j++ {
                if i != j {
                    result = (a0[i] - a0[j]) * result
                }
            }
            roots.append(a0[i] - (eval(coefficients, a0[i]) / result))
        }
        if done(a0, roots) {
            return Multiset(roots)
        }
        a0 = roots
    }
    
    return Multiset(a0)
}

private func eval<Real: RealType>(coefficients: [Complex<Real>], x: Complex<Real>) -> Complex<Real> {
    var result = coefficients[0]
    for i in 1..<coefficients.count {
        result = (result * x) + coefficients[i]
    }
    return result
}

private func done<Real: RealType>(aa: [Complex<Real>], bb: [Complex<Real>], epsilon: Real = Real.epsilon) -> Bool {
    for (a, b) in zip(aa, bb) {
        let delta = a - b
        if delta.abs > epsilon {
            return false
        }
    }
    return true
}
