//
//  Polinomial.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 08/01/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation
import Set

public struct Polynomial<Real: RealType>: Equatable {
    
    let coefficients: [Real]
    
    /**
    Creates a new instance of `Polynomial` with the given coefficients.
    
    :param: coefficients The coefficients for the terms of the polinomial, ordered from the coefficient for the highest-degree term to the coefficient for the 0 degree term.
    */
    public init(_ coefficients: Real...) {
        self.init(coefficients)
    }
    
    /**
    Creates a new instance of `Polynomial` with the given coefficients.
    
    :param: coefficients The coefficients for the terms of the polinomial, ordered from the coefficient for the highest-degree term to the coefficient for the 0 degree term.
    */
    public init(_ coefficients: [Real]) {
        if coefficients.count == 0 || (coefficients.count == 1 && coefficients[0].isZero) {
            preconditionFailure("the zero polynomial is undefined")
        }
        self.coefficients = coefficients
    }
    
    /// The grade of the polinomial. It's equal to the number of coefficient minus one.
    public var degree: Int {
        return coefficients.count - 1
    }
    
    /// Finds the roots of the polinomial.
    public func roots(preferClosedFormSolution preferClosedFormSolution: Bool = true) -> Multiset<Complex<Real>> {
        if (preferClosedFormSolution && degree <= 4) {
            switch degree {
            case 0:
                return [] // Empty set (i.e. no solutions to `k = 0`, when k != 0)
            case 1:
                return linear()
            case 2:
                return quadratic()
            case 3:
                return cubic()
            case 4:
                return quartic()
            default:
                fatalError("Not reachable")
            }
        } else {
            return durandKernerMethod()
        }
    }
    
    // MARK: Private methods
    
    private func linear() -> Multiset<Complex<Real>> {
        let a = coefficients[0]
        let b = coefficients[1]

        if a.isZero {
            return []
        }
        
        let x = -b/a
        return [Complex(x, 0.0)]
    }
    
    private func quadratic() -> Multiset<Complex<Real>> {
        let a = coefficients[0]
        let b = coefficients[1]
        let c = coefficients[2]
        
        if a.isZero {
            return Polynomial(b, c).roots()
        }
        
        if c.isZero {
            return [Complex.zero()] + Polynomial(a, b).roots()
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
    
    private func cubic() -> Multiset<Complex<Real>> {
        let a = coefficients[0]
        var b = coefficients[1]
        var c = coefficients[2]
        var d = coefficients[3]
        
        if a.isZero {
            return Polynomial(b, c, d).roots()
        }
        if d.isZero {
            return [Complex.zero()] + Polynomial(a, b, c).roots()
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
        let D12 = D1 * D1
        let D03 = D0 * D0 * D0
        let minus27D = D12 - (4.0 * D03)
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
            
            let im = Complex(0.0, Real(0.5*sqrt(3.0)))
            let u2 = Real(-0.5) + im
            let u3 = Real(-0.5) - im
            let u2C = u2 * C
            let u3C = u3 * C
            
            let x13 = b + C + (D0 / C)
            let x23 = b + u2C + (D0 / u2C)
            let x33 = b + u3C + (D0 / u3C)
            
            let x1 = -oneThird * x13
            let x2 = -oneThird * x23
            let x3 = -oneThird * x33
            
            return [x1, x2, x3]
        }
    }
    
    private func quartic() -> Multiset<Complex<Real>> {
        var a = coefficients[0]
        var b = coefficients[1]
        var c = coefficients[2]
        var d = coefficients[3]
        let e = coefficients[4]
        
        if a.isZero {
            return Polynomial(b, c, d, e).roots()
        }
        if e.isZero {
            return [Complex.zero()] + Polynomial(a, b, c, d).roots()
        }
        if b.isZero && d.isZero { // Biquadratic
            let squares = Polynomial(a, c, e).roots()
            return squares.flatMap { (square: Complex<Real>) -> Multiset<Complex<Real>> in
                let x = sqrt(square)
                return [x, -x]
            }
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
        let ab4 = 4.0*a*b
        let q = (a2*a - ab4)/8.0 + c
        let r1 = minus3a2*a2 - ac64 + a2b16
        let r = r1/256.0 + d
        
        // Depressed quartic: u^4 + p*u^2 + q*u + r = 0
        
        if q.isZero { // Depressed quartic is biquadratic
            let squares = Polynomial(1.0, p, r).roots()
            return squares.flatMap { (square: Complex<Real>) -> Multiset<Complex<Real>> in
                let x = sqrt(square)
                return [x - aOn4, -x - aOn4]
            }
        }
        
        let p2 = p*p
        let q2On8 = q*q/8.0
        
        let cb = 2.5*p
        let cc = 2.0*p2 - r
        let cd = 0.5*p*(p2-r) - q2On8
        let yRoots = Polynomial(1.0, cb, cc, cd).roots()
        
        let y = yRoots[yRoots.startIndex]
        let y2 = 2.0*y
        let sqrtPPlus2y = sqrt(p + y2)
        precondition(sqrtPPlus2y.isZero == false, "Failed to properly handle the case of the depressed quartic being biquadratic")
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
    
    /// Implementation of the [Durand-Kerner-Weierstrass method](https://en.wikipedia.org/wiki/Durand%E2%80%93Kerner_method).
    private func durandKernerMethod() -> Multiset<Complex<Real>> {
        var coefficients = self.coefficients.map { Complex($0, Real(0)) }
        
        let one = Complex(Real(1), Real(0))
        
        if coefficients[0] != one {
            coefficients = coefficients.map { coefficient in
                coefficient / coefficients[0]
            }
        }
        
        var a0 = [one]
        for _ in 1..<coefficients.count-1 {
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
    
    private func eval<Real: RealType>(coefficients: [Complex<Real>], _ x: Complex<Real>) -> Complex<Real> {
        var result = coefficients[0]
        for i in 1..<coefficients.count {
            result = (result * x) + coefficients[i]
        }
        return result
    }
    
    private func done<Real: RealType>(aa: [Complex<Real>], _ bb: [Complex<Real>], _ epsilon: Real = Real.epsilon) -> Bool {
        for (a, b) in zip(aa, bb) {
            let delta = a - b
            if delta.abs > epsilon {
                return false
            }
        }
        return true
    }
    
}

// MARK: Equatable

public func == <Real: RealType>(lhs: Polynomial<Real>, rhs: Polynomial<Real>) -> Bool {
    return lhs.coefficients == rhs.coefficients
}

