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
        return analysis(ifFloat: { myself in
            SwiftMath.sum(myself)
        }, ifDouble: { myself in
            SwiftMath.sum(myself)
        })
    }
    
    public func absoluteSum() -> Element {
        return analysis(ifFloat: { myself in
            asum(myself)
        }, ifDouble: { myself in
            asum(myself)
        })
    }
    
    public func maxElement() -> Element? {
        if self.isEmpty { return nil }
        return analysis(ifFloat: { myself in
            max(myself)
        }, ifDouble: { myself in
            max(myself)
        })
    }
    
    public func minElement() -> Element? {
        if self.isEmpty { return nil }
        return analysis(ifFloat: { myself in
            min(myself)
        }, ifDouble: { myself in
            min(myself)
        })
    }
    
    public func mean() -> Element {
        return analysis(ifFloat: { myself in
            SwiftMath.mean(myself)
        }, ifDouble: { myself in
            SwiftMath.mean(myself)
        })
    }
    
    public func meanMagnitude() -> Element {
        return analysis(ifFloat: { myself in
            meamg(myself)
        }, ifDouble: { myself in
            meamg(myself)
        })
    }
    
    public func meanSquareValue() -> Element {
        return analysis(ifFloat: { myself in
            measq(myself)
        }, ifDouble: { myself in
            measq(myself)
        })
    }
    
    public func squareRoots() -> [Element] {
        return analysis(ifFloat: { myself in
            sqrt(myself)
        }, ifDouble: { myself in
            sqrt(myself)
        })
    }
    
}
