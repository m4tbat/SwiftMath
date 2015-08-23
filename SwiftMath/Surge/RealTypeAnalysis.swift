//
//  RealTypeAnalysis.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 23/08/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

func analysis<Real: RealType>(x: [Real], _ y: [Real], @noescape ifFloat: ([Float], [Float]) -> Float, @noescape ifDouble: ([Double], [Double]) -> Double) -> Real {
    if Real.self == Float.self {
        return Real(ifFloat(unsafeBitCast(x, [Float].self), unsafeBitCast(y, [Float].self)))
    } else if Real.self == Double.self {
        return Real(ifDouble(unsafeBitCast(x, [Double].self), unsafeBitCast(y, [Double].self)))
    }
    fatalError("Accelerate-backed array methods work only with Float or Double elements")
}

func analysis<Real: RealType>(x: [Real], _ y: [Real], @noescape ifFloat: ([Float], [Float]) -> [Float], @noescape ifDouble: ([Double], [Double]) -> [Double]) -> [Real] {
    if Real.self == Float.self {
        return unsafeBitCast(ifFloat(unsafeBitCast(x, [Float].self), unsafeBitCast(y, [Float].self)), [Real].self)
    } else if Real.self == Double.self {
        return unsafeBitCast(ifDouble(unsafeBitCast(x, [Double].self), unsafeBitCast(y, [Double].self)), [Real].self)
    }
    fatalError("Accelerate-backed array methods work only with Float or Double elements")
}


