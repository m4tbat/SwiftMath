//
//  PolynomialsTests.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 07/05/15.
//  Copyright (c) 2015 Matteo Battaglio. All rights reserved.
//

import Foundation
import SwiftMath
import Quick
import Nimble

class PolynomialsSpec: QuickSpec {
    
    override func spec() {
        let minus1 = -1 + 0.i
        let imaginary = 1.i
        
        describe("linear") {
            it("has 1 root [x = -b/a] iff a != 0") {
                expect(linear(1, 1)).to(equal([minus1]))
            }
            it("has no solutions iff a == 0") {
                expect(linear(0, 1)).to(beEmpty())
            }
        }
        
        describe("quadratic") {
            it("has 2 roots iff a != 0") {
                expect(quadratic(1, 2, 1)).to(equal([minus1, minus1]))
                
                expect(quadratic(1, 0, 1)).to(equal([-imaginary, imaginary]))
            }
            it("equals linear(b, c) iff a == 0") {
                expect(quadratic(0, 1, 1)).to(equal(linear(1, 1)))
            }
        }
        
        describe("cubic") {
            it("has 3 roots iff a != 0") {
                expect(cubic(1, 3, 3, 1)).to(equal([minus1, minus1, minus1]))
                
                expect(cubic(1, 1, 1, 1)).to(beCloseTo([minus1, -imaginary, imaginary]))
            }
            it("equals quadratic(b, c, d) iff a == 0") {
                expect(cubic(0, 1, 2, 1)).to(equal(quadratic(1, 2, 1)))
            }
        }
        
        describe("quartic") {
            it("has 4 roots iff a != 0") {
                expect(quartic(5, 1, 3, -3, 10).count).to(equal(4))
                
                let x1 = -pow(-1+0.i, 0.2)
                let x2 = pow(-1+0.i, 0.4)
                let x3 = -pow(-1+0.i, 0.6)
                let x4 = pow(-1+0.i, 0.8)
                expect(quartic(1, 1, 1, 1, 1)).to(beCloseTo([x2, x3, x4, x1]))
                
                expect(quartic(1, 4, 6, 4, 1)).to(equal([minus1, minus1, minus1, minus1]))
            }
            it("equals cubic(b, c, d, e) iff a == 0") {
                expect(quartic(0, 1, 3, 3, 1)).to(equal(cubic(1, 3, 3, 1)))
            }
            it("has 0 as root, and the other three are cubic(a, b, c, d), if e == 0") {
                expect(quartic(1, 3, 3, 1, 0)).to(equal([Complex.zero()] + cubic(1, 3, 3, 1)))
            }
        }
    }
    
}