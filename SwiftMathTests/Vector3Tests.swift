//
//  VectorR3Tests.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 31/05/15.
//  Copyright (c) 2015 GlidingSwift. All rights reserved.
//

import Foundation
import SwiftMath
import Quick
import Nimble

class Vector3Spec: QuickSpec {
    
    override func spec() {
        let v1 = Vector3(x: 1, y: 2, z: 3)
        let v2 = Vector3(x: 5, y: 6, z: 7)
        let v3 = Vector3(x: -20, y: 0, z: -5)
        
        describe("addition") {
            it("sums each component of one vector to the corresponding component of the other vector") {
                expect(v1 + v2).to(equal(Vector3(x: v1.x + v2.x, y: v1.y + v2.y, z: v1.z + v2.z)))
            }
            it("is commutative") {
                expect(v1 + v2).to(equal(v2 + v1))
            }
            it("is associative") {
                expect(v1 + (v2 + v3)).to(equal((v1 + v2) + v3))
            }
            it("has an identity element: the zero vector") {
                expect(v1 + .zero()).to(equal(v1))
            }
        }
        
        describe("subtraction") {
            it("subtracts each component of one vector from the corresponding component of the other vector") {
                expect(v1 - v2).to(equal(Vector3(x: v1.x - v2.x, y: v1.y - v2.y, z: v1.z - v2.z)))
            }
        }
        
        describe("multiplication") {
            it("is associative") {
                expect(3 * (2 * v1)).to(equal((3 * 2) * v1))
            }
            it("is distributive") {
                var expected = (5 * v1) + (5 * v2)
                expect(5 * (v1 + v2)).to(equal(expected))
                
                expected = (5 * v1) + (6 * v1)
                expect((5 + 6) * v1).to(equal(expected))
            }
        }
        
        describe("rotation") {
            it("rotates a vector as expected") {
                let original = Vector3(x: 3, y: 4, z: 0)
                let rotation = Quaternion(axis: Vector3(x: 1, y: 0, z: 0), angle: Double.PI/2.0)
                let result = original.rotate(rotation)
                let expected = Vector3(x: 3, y: 0, z: 4.0)
                expect(result).to(beCloseTo(expected))
                
                expect(result.length).to(equal(original.length))
            }
        }
        
    }
    
}