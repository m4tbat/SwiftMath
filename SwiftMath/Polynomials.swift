//
//  Polinomials.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 08/01/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

public func linear<Real: RealType>(a: Real, b: Real) -> [Complex<Real>] {
    if a.isZero {
        return []
    }
    
    let x = -b/a
    return [Complex(x, 0.0)]
}

public func quadratic<Real: RealType>(a: Real, b: Real, c: Real) -> [Complex<Real>] {
    if a.isZero {
        return linear(b, c)
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

public func cubic<Real: RealType>(a: Real, var b: Real, var c: Real, var d: Real) -> [Complex<Real>] {
    if a.isZero {
        return quadratic(b, c, d)
    }
    
    b /= a
    c /= a
    d /= a
    
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

public func quartic<Real: RealType>(a: Real, var b: Real, var c: Real, var d: Real, var e: Real) -> [Complex<Real>] {
    if a.isZero {
        return cubic(b, c, d, e)
    }
    
    b /= a
    c /= a
    d /= a
    e /= a
    
    let b2 = b * b
    let c2 = c * c
    let d2 = d * d
    
    let p = 2.0*(c - (3.0/8.0 * b2))
    let bc4 = 4.0 * b * c
    let q = (((b2 * b) - bc4) / 8.0) + d
    
    let D0 = c2 - (3.0 * b * d) + (12.0 * e)
    let bcd9 = 9.0 * b * c * d
    let ce72 = 72.0 * c * e
    let D1_1 = (2.0 * c2 * c) - bcd9
    let D1_2 = 27.0 * ((b2 * e) + d2)
    let D1 = D1_1 + D1_2 - ce72
    let minus27D = (D1 * D1) - (4.0 * D0 * D0 * D0)
    var squareRoot = sqrt(Complex(minus27D, 0.0))
    let oneThird: Real = 1.0/3.0
    let zero: Real = 0.0
    
    if D0.isZero && !minus27D.isZero {
        if (D1 + squareRoot) == zero {
            squareRoot = -squareRoot
        }
    }
    
    let Q = pow(0.5 * (D1 + squareRoot), oneThird)
    
    if Q == zero {
        // FIXME: handle special case of Q == 0
//        preconditionFailure("Quartic with Q == 0 => case not yet implemented.")
        return []
        // It means necessarily that D0 == 0 && D1 == 0
        // => at least three roots are equal, and the roots are rational functions of the coefficients.
    } else {
        let z1 = -oneThird * p
        let z3 = Q + (D0 / Q)
        let S = 0.5 * sqrt(z1 + (oneThird * z3))
        let minus_b_4a = -b / 4.0
        
        if S == zero {
            let firstPart = -3.0*b2*b2/256.0
            let secondPart = c*b2/16.0
            let thirdPart = minus_b_4a*d
            let fourthPart = e
            if firstPart + secondPart + thirdPart + fourthPart == zero {
                let x = Complex(minus_b_4a, zero)
                return [x, x, x, x]
            }
            
            // The numerator of q is zero, and the associated depressed quartic is biquadratic.
            let squares = quadratic(a, c, e)
            
            let x1 = sqrt(squares[0])
            let x2 = sqrt(squares[1])
            
            return [x1, -x1, x2, -x2]
        } else {
            let u = (-4.0 * S * S) - p
            let qOnS = q / S
            let squareRoot12 = 0.5 * sqrt(u + qOnS)
            let squareRoot34 = 0.5 * sqrt(u - qOnS)
            let w12 = minus_b_4a - S
            let w34 = minus_b_4a + S
            
            let x1 = w12 + squareRoot12
            let x2 = w12 - squareRoot12
            let x3 = w34 + squareRoot34
            let x4 = w34 - squareRoot34
            
            return [x1, x2, x3, x4]
        }
    }
}

/// Finds the roots of the polinomial whose coefficients are the passed arguments.
/// The grade of the polinomial is equal to the number of arguments minus one (coefficients.count - 1).
/// E.g. invoking polynomial(1, 2, 3, 4) (grade 3) will compute the (three) roots of: x^3 + 2x^2 + 3x + 4 = 0
public func polynomial<Real: RealType>(coefficients: Real...) -> [Complex<Real>] {
    switch coefficients.count {
    case 0:
        preconditionFailure("the zero polynomial is undefined")
    case 1:
        if coefficients[0].isZero {
            preconditionFailure("the zero polynomial is undefined")
        }
        return []
    case 2:
        return linear(coefficients[0], coefficients[1])
    case 3:
        return quadratic(coefficients[0], coefficients[1], coefficients[2])
    case 4:
        return cubic(coefficients[0], coefficients[1], coefficients[2], coefficients[3])
    case 5:
        return quartic(coefficients[0], coefficients[1], coefficients[2], coefficients[3], coefficients[4])
    default:
        // TODO : Implement some root finding algorithm for polynomials of degree > 4
        return []
    }
}
