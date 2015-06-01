//
//  ComplexTests.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 06/05/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation
import SwiftMath
import Quick
import Nimble

class ComplexSpec: QuickSpec {
    
    override func spec() {
        var c: Complex<Double>!
        var d: Complex<Double>!
        
        beforeEach {
            c = Complex(3.0, -5.0)
            d = Complex(-7.0, 120.0)
        }
        
        describe("complex number") {
            it("is real iff .im < epsilon") {
                let realComplex = Complex(42.0, 0.9*Double.epsilon)
                expect(realComplex.isReal).to(beTrue())
                let nonRealComplex = Complex(42.0, 1.1*Double.epsilon)
                expect(nonRealComplex.isReal).to(beFalse())
            }
        }
        
        describe("conjugation") {
            it("gives a complex number with the same real part and opposite imaginary part") {
                let expected = Complex(c.re, -c.im)
                expect(c.conj()).to(equal(expected))
            }
        }
        
        describe("reciprocal") {
            it("is the division of itself by the sum of the squares of its real part and its imaginary part") {
                let expected = c.conj() / (c.re * c.re + c.im * c.im)
                expect(c.reciprocal()).to(equal(expected))
            }
        }
        
        describe("addition") {
            it("consists of adding the real and imaginary parts of the summands") {
                let expected = Complex(c.re + d.re, c.im + d.im)
                expect(c + d).to(equal(expected))
            }
            it("is commutative") {
                expect(c + d).to(equal(d + c))
            }
        }
        
        describe("subtraction") {
            it("consists of subtracting the real and imaginary parts of the terms") {
                let expected = Complex(c.re - d.re, c.im - d.im)
                expect(c - d).to(equal(expected))
            }
        }
        
        describe("multiplication") {
            it("implements the formula for complex number multiplication") {
                let expected = Complex(c.re * d.re - c.im * d.im, c.im * d.re + c.re * d.im)
                expect(c * d).to(equal(expected))
            }
            it("is commutative") {
                expect(c * d).to(equal(d * c))
            }
        }
        
        describe("division") {
            it("implements the formula for complex number division") {
                let denom = d.re * d.re + d.im * d.im
                let realPart = (c.re * d.re + c.im * d.im)/denom
                let imagPart = (c.im * d.re - c.re * d.im)/denom
                let expected = Complex(realPart, imagPart)
                expect(c / d).to(equal(expected))
            }
        }
        
        describe("exponentiation") {
            it("correctly handles corner cases (i.e. x^0, 0^x)") {
                expect(Complex.zero() ** 0.0).to(equal(Complex(1.0, 0.0)))
                expect(Complex(9999.0, 0.0) ** 0.0).to(equal(Complex(1.0, 0.0)))
                expect(Complex.zero() ** 9999.0).to(equal(Complex.zero()))
            }
        }
        
        describe("principal square root") {
            it("equals itself exponentiated to the 0.5") {
                expect(sqrt(c)).to(equal(c ** 0.5))
            }
        }
    }
    
}