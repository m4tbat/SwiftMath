//
//  PolynomialsTests.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 07/05/15.
//  Copyright (c) 2015 GlidingSwift. All rights reserved.
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
                let biquadratic = quartic(1, 0, 2, 0, 1)
                println(biquadratic)
                
                let minus1 = -1 + 0.i
                expect(quartic(1, 4, 6, 4, 1)).to(beCloseTo([minus1, minus1, minus1, minus1]))
            }
            
            it("equals cubic(b, c, d, e) iff a == 0") {
                expect(quartic(0, 1, 3, 3, 1)).to(equal(cubic(1, 3, 3, 1)))
            }
        }
    }
    
}