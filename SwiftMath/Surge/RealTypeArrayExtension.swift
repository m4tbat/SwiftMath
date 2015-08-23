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
    
    private func analysis(@noescape ifFloat ifFloat: ([Float]) -> ([Float], [Float]), @noescape ifDouble: ([Double]) -> ([Double], [Double])) -> ([Element], [Element]) {
        if Element.self == Float.self {
            let result = ifFloat(unsafeBitCast(self, [Float].self))
            return (unsafeBitCast(result.0, [Element].self), unsafeBitCast(result.1, [Element].self))
        } else if Element.self == Double.self {
            let result = ifFloat(unsafeBitCast(self, [Double].self))
            return (unsafeBitCast(result.0, [Element].self), unsafeBitCast(result.1, [Element].self))
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
    
    // MARK: Trigonometric
    
    public func sine() -> [Element] {
        return analysis(ifFloat: sin, ifDouble: sin)
    }
    
    public func cosine() -> [Element] {
        return analysis(ifFloat: cos, ifDouble: cos)
    }
    
    public func sineCosine() -> (sin: [Element], cos: [Element]) {
        return analysis(ifFloat: sincos, ifDouble: sincos)
    }
    
    public func tangent() -> [Element] {
        return analysis(ifFloat: tan, ifDouble: tan)
    }
    
    public func ascsine() -> [Element] {
        return analysis(ifFloat: asin, ifDouble: asin)
    }
    
    public func arccosine() -> [Element] {
        return analysis(ifFloat: acos, ifDouble: acos)
    }
    
    public func arctangent() -> [Element] {
        return analysis(ifFloat: atan, ifDouble: atan)
    }
    
    public func radiansToDegrees() -> [Element] {
        return analysis(ifFloat: rad2deg, ifDouble: rad2deg)
    }
    
    public func degreesToRadians() -> [Element] {
        return analysis(ifFloat: deg2rad, ifDouble: deg2rad)
    }
    
    // MARK: Hyperbolic
    
    public func hyperbolicSine() -> [Element] {
        return analysis(ifFloat: sinh, ifDouble: sinh)
    }
    
    public func hyperbolicCosine() -> [Element] {
        return analysis(ifFloat: cosh, ifDouble: cosh)
    }
    
    public func hyperbolicTangent() -> [Element] {
        return analysis(ifFloat: tanh, ifDouble: tanh)
    }
    
    public func hyperbolicArcsine() -> [Element] {
        return analysis(ifFloat: asinh, ifDouble: asinh)
    }
    
    public func hyperbolicArccosine() -> [Element] {
        return analysis(ifFloat: acosh, ifDouble: acosh)
    }
    
    public func hyperbolicArctangent() -> [Element] {
        return analysis(ifFloat: atanh, ifDouble: atanh)
    }
    
}
