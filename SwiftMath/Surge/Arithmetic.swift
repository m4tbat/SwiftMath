// Arithmetic.swift
//
// Copyright (c) 2014–2015 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Accelerate

// MARK: Sum

func sum(x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_sve(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

func sum(x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_sveD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Sum of Absolute Values

func asum(x: [Float]) -> Float {
    return cblas_sasum(Int32(x.count), x, 1)
}

func asum(x: [Double]) -> Double {
    return cblas_dasum(Int32(x.count), x, 1)
}

// MARK: Maximum

func max(x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_maxv(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

func max(x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_maxvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Minimum

func min(x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_minv(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

func min(x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_minvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Mean

func mean(x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_meanv(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

func mean(x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_meanvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Mean Magnitude

func meamg(x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_meamgv(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

func meamg(x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_meamgvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Mean Square Value

func measq(x: [Float]) -> Float {
    var result: Float = 0.0
    vDSP_measqv(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

func measq(x: [Double]) -> Double {
    var result: Double = 0.0
    vDSP_measqvD(x, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: Square Root

func sqrt(x: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvsqrtf(&results, x, [Int32(x.count)])
    
    return results
}

func sqrt(x: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vvsqrt(&results, x, [Int32(x.count)])
    
    return results
}

// MARK: Add

public func add<Real: RealType>(x: [Real], _ y: [Real]) -> [Real] {
    return analysis(x, y, ifFloat: { x, y in
        add(x, y)
    }, ifDouble: { x, y in
        add(x, y)
    })
}

func add(x: [Float], _ y: [Float]) -> [Float] {
    var results = [Float](y)
    cblas_saxpy(Int32(x.count), 1.0, x, 1, &results, 1)
    
    return results
}

func add(x: [Double], _ y: [Double]) -> [Double] {
    var results = [Double](y)
    cblas_daxpy(Int32(x.count), 1.0, x, 1, &results, 1)
    
    return results
}

// MARK: Multiply

public func mul<Real: RealType>(x: [Real], _ y: [Real]) -> [Real] {
    return analysis(x, y, ifFloat: { x, y in
        mul(x, y)
    }, ifDouble: { x, y in
        mul(x, y)
    })
}

func mul(x: [Float], _ y: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vDSP_vmul(x, 1, y, 1, &results, 1, vDSP_Length(x.count))
    
    return results
}

func mul(x: [Double], _ y: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vDSP_vmulD(x, 1, y, 1, &results, 1, vDSP_Length(x.count))
    
    return results
}

// MARK: Divide

public func div<Real: RealType>(x: [Real], _ y: [Real]) -> [Real] {
    return analysis(x, y, ifFloat: { x, y in
        div(x, y)
    }, ifDouble: { x, y in
        div(x, y)
    })
}

func div(x: [Float], _ y: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvdivf(&results, x, y, [Int32(x.count)])
    
    return results
}

func div(x: [Double], _ y: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vvdiv(&results, x, y, [Int32(x.count)])
    
    return results
}

// MARK: Modulo

public func mod<Real: RealType>(x: [Real], _ y: [Real]) -> [Real] {
    return analysis(x, y, ifFloat: { x, y in
        mod(x, y)
    }, ifDouble: { x, y in
        mod(x, y)
    })
}

func mod(x: [Float], _ y: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvfmodf(&results, x, y, [Int32(x.count)])
    
    return results
}

func mod(x: [Double], _ y: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vvfmod(&results, x, y, [Int32(x.count)])
    
    return results
}

// MARK: Remainder

public func remainder<Real: RealType>(x: [Real], _ y: [Real]) -> [Real] {
    return analysis(x, y, ifFloat: { x, y in
        remainder(x, y)
    }, ifDouble: { x, y in
        remainder(x, y)
    })
}

func remainder(x: [Float], _ y: [Float]) -> [Float] {
    var results = [Float](count: x.count, repeatedValue: 0.0)
    vvremainderf(&results, x, y, [Int32(x.count)])
    
    return results
}

func remainder(x: [Double], _ y: [Double]) -> [Double] {
    var results = [Double](count: x.count, repeatedValue: 0.0)
    vvremainder(&results, x, y, [Int32(x.count)])
    
    return results
}

// MARK: Dot Product

public func dot<Real: RealType>(x: [Real], _ y: [Real]) -> Real {
    precondition(x.count == y.count, "Vectors must have equal count")
    
    return analysis(x, y, ifFloat: { x, y in
        dot(x, y)
    }, ifDouble: { x, y in
        dot(x, y)
    })
}

func dot(x: [Float], _ y: [Float]) -> Float {
    precondition(x.count == y.count, "Vectors must have equal count")
    
    var result: Float = 0.0
    vDSP_dotpr(x, 1, y, 1, &result, vDSP_Length(x.count))
    
    return result
}


func dot(x: [Double], _ y: [Double]) -> Double {
    precondition(x.count == y.count, "Vectors must have equal count")
    
    var result: Double = 0.0
    vDSP_dotprD(x, 1, y, 1, &result, vDSP_Length(x.count))
    
    return result
}

// MARK: - Operators

public func + <Real: RealType>(lhs: [Real], rhs: [Real]) -> [Real] {
    return add(lhs, rhs)
}

public func + <Real: RealType>(lhs: [Real], rhs: Real) -> [Real] {
    return add(lhs, [Real](count: lhs.count, repeatedValue: rhs))
}

public func / <Real: RealType>(lhs: [Real], rhs: [Real]) -> [Real] {
    return div(lhs, rhs)
}

public func / <Real: RealType>(lhs: [Real], rhs: Real) -> [Real] {
    return div(lhs, [Real](count: lhs.count, repeatedValue: rhs))
}

public func * <Real: RealType>(lhs: [Real], rhs: [Real]) -> [Real] {
    return mul(lhs, rhs)
}

public func * <Real: RealType>(lhs: [Real], rhs: Real) -> [Real] {
    return mul(lhs, [Real](count: lhs.count, repeatedValue: rhs))
}

public func % <Real: RealType>(lhs: [Real], rhs: [Real]) -> [Real] {
    return mod(lhs, rhs)
}

public func % <Real: RealType>(lhs: [Real], rhs: Real) -> [Real] {
    return mod(lhs, [Real](count: lhs.count, repeatedValue: rhs))
}

infix operator • { associativity left precedence 150 }
public func • <Real: RealType>(lhs: [Real], rhs: [Real]) -> Real {
    return dot(lhs, rhs)
}
