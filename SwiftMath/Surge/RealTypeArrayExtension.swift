//
//  RealTypeArrayExtension.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 23/08/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

extension Array where Element: RealType {
    
    private func analysis(@noescape ifFloat ifFloat: ([Float]) -> Float, @noescape ifDouble: ([Double]) -> Double) -> Element {
        if Element.self == Float.self {
            return Element(ifFloat(unsafeBitCast(self, [Float].self)))
        } else if Element.self == Double.self {
            return Element(ifDouble(unsafeBitCast(self, [Double].self)))
        }
        fatalError("Accelerate-backed array methods work only with Float or Double elements")
    }
    
    private func analysis(@noescape ifFloat ifFloat: ([Float]) -> [Float], @noescape ifDouble: ([Double]) -> [Double]) -> [Element] {
        if Element.self == Float.self {
            return unsafeBitCast(ifFloat(unsafeBitCast(self, [Float].self)), [Element].self)
        } else if Element.self == Double.self {
            return unsafeBitCast(ifDouble(unsafeBitCast(self, [Double].self)), [Element].self)
        }
        fatalError("Accelerate-backed array methods work only with Float or Double elements")
    }
    
    // MARK: Arithmetic
    
    public func sum() -> Element {
        return analysis(ifFloat: SwiftMath.sum, ifDouble: SwiftMath.sum)
    }
    
    public func absoluteSum() -> Element {
        return analysis(ifFloat: asum, ifDouble: asum)
    }
    
    public func maxElement() -> Element? {
        if self.isEmpty { return nil }
        return analysis(ifFloat: max, ifDouble: max)
    }
    
    public func minElement() -> Element? {
        if self.isEmpty { return nil }
        return analysis(ifFloat: min, ifDouble: min)
    }
    
    public func mean() -> Element {
        return analysis(ifFloat: SwiftMath.mean, ifDouble: SwiftMath.mean)
    }
    
    public func meanMagnitude() -> Element {
        return analysis(ifFloat: meamg, ifDouble: meamg)
    }
    
    public func meanSquareValue() -> Element {
        return analysis(ifFloat: measq, ifDouble: measq)
    }
    
    public func squareRoots() -> [Element] {
        return analysis(ifFloat: sqrt, ifDouble: sqrt)
    }
    
    // MARK: Auxiliary
    
    public func absolute() -> [Element] {
        return analysis(ifFloat: abs, ifDouble: abs)
    }
    
    public func ceiling() -> [Element] {
        return analysis(ifFloat: ceil, ifDouble: ceil)
    }
    
    public func floor() -> [Element] {
        return analysis(ifFloat: SwiftMath.floor, ifDouble: SwiftMath.floor)
    }
    
    public func negate() -> [Element] {
        return analysis(ifFloat: neg, ifDouble: neg)
    }
    
    public func reciprocal() -> [Element] {
        return analysis(ifFloat: rec, ifDouble: rec)
    }
    
    public func round() -> [Element] {
        return analysis(ifFloat: SwiftMath.round, ifDouble: SwiftMath.round)
    }
    
    public func truncate() -> [Element] {
        return analysis(ifFloat: trunc, ifDouble: trunc)
    }
    
    public func threshold(low: Element) -> [Element] {
        return analysis(ifFloat: { myself in
            SwiftMath.threshold(myself, low as! Float)
        }, ifDouble: { myself in
            SwiftMath.threshold(myself, low as! Double)
        })
    }
    
    public func clip(interval: ClosedInterval<Element>) -> [Element] {
        return analysis(ifFloat: { myself in
            SwiftMath.clip(myself, interval.start as! Float, interval.end as! Float)
        }, ifDouble: { myself in
            SwiftMath.clip(myself, interval.start as! Double, interval.end as! Double)
        })
    }
    
    // MARK: Exponential
    
    public func exponential() -> [Element] {
        return analysis(ifFloat: exp, ifDouble: exp)
    }
    
    public func squareExponential() -> [Element] {
        return analysis(ifFloat: exp2, ifDouble: exp2)
    }
    
    public func naturalLogarithm() -> [Element] {
        return analysis(ifFloat: log, ifDouble: log)
    }
    
    public func base2Logarithm() -> [Element] {
        return analysis(ifFloat: log2, ifDouble: log2)
    }
    
    public func base10Logarithm() -> [Element] {
        return analysis(ifFloat: log10, ifDouble: log10)
    }
    
    public func logarithmicExponential() -> [Element] {
        return analysis(ifFloat: logb, ifDouble: logb)
    }
    
    // MARK: Fast Fourier Transform
    
    public func fastFourierTransform() -> [Element] {
        return analysis(ifFloat: fft, ifDouble: fft)
    }
    
    // MARK: Hyperbolic
    
    public func sinh() -> [Element] {
        return analysis(ifFloat: SwiftMath.sinh, ifDouble: SwiftMath.sinh)
    }
    
    public func cosh() -> [Element] {
        return analysis(ifFloat: SwiftMath.cosh, ifDouble: SwiftMath.cosh)
    }
    
    public func tanh() -> [Element] {
        return analysis(ifFloat: SwiftMath.tanh, ifDouble: SwiftMath.tanh)
    }
    
    public func asinh() -> [Element] {
        return analysis(ifFloat: SwiftMath.asinh, ifDouble: SwiftMath.asinh)
    }
    
    public func acosh() -> [Element] {
        return analysis(ifFloat: SwiftMath.acosh, ifDouble: SwiftMath.acosh)
    }
    
    public func atanh() -> [Element] {
        return analysis(ifFloat: SwiftMath.atanh, ifDouble: SwiftMath.atanh)
    }
    
}
