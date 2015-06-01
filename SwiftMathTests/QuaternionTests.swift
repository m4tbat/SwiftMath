//
//  QuaternionTests.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 31/05/15.
//  Copyright (c) 2015 GlidingSwift. All rights reserved.
//

import Foundation
import SwiftMath
import Quick
import Nimble

class QuaternionSpec: QuickSpec {
    
    override func spec() {
        var c: Quaternion<Double>!
        var d: Quaternion<Double>!
        
        beforeEach {
            c = Quaternion(3, VectorR3(x: 1, y: 2, z: 3))
            d = Quaternion(7.0, VectorR3(x: 5, y: 4, z: 3))
        }
        
        describe("Quaternion") {
            it("is real iff .im == the zero vector") {
                let realQuaternion = Quaternion(42.0, .zero())
                expect(realQuaternion.isReal).to(beTrue())
                let nonRealQuaternion = Quaternion(42.0, VectorR3(x: 1, y: 2, z: 3))
                expect(nonRealQuaternion.isReal).to(beFalse())
            }
        }
        
        describe("conjugation") {
            it("gives a quaternion with the same real part and opposite imaginary part") {
                let expected = Quaternion(c.re, -c.im)
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
                let expected = Quaternion(c.re + d.re, c.im + d.im)
                expect(c + d).to(equal(expected))
            }
            it("is commutative") {
                expect(c + d).to(equal(d + c))
            }
        }
        
        describe("subtraction") {
            it("consists of subtracting the real and imaginary parts of the terms") {
                let expected = Quaternion(c.re - d.re, c.im - d.im)
                expect(c - d).to(equal(expected))
            }
        }
        
        describe("multiplication") {
            it("is commutative") {
                expect(c * d).to(equal(d * c))
            }
        }
        
    }
    
}