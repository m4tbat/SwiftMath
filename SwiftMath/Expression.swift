//
//  Expression.swift
//  SwiftMath
//
//  Created by Matteo Battaglio on 25/07/15.
//  Copyright © 2015 Matteo Battaglio. All rights reserved.
//

import Foundation

enum Operation {
    case Unary(function: (Double) -> Double)
    case Binary(value: Double, function: (Double, Double) -> Double, direction: Direction)
}

enum Direction {
    case ExprThenValue
    case ValueThenExpr
}

public struct Expression {
    
    var operations: [Operation] = []
    
    public init() {
        
    }
    
    init(_ operations: [Operation]) {
        self.operations = operations
    }
    
    public func evaluateFor(variableValue: Double) -> Double {
        return operations.reduce(variableValue) { (exprValue, operation) in
            switch operation {
            case let .Unary(function):
                return function(exprValue)
            case let .Binary(value, function, direction):
                return direction == .ExprThenValue ? function(exprValue, value) : function(value, exprValue)
            }
        }
    }
    
    func composeWith(value value: Double, function: (Double, Double) -> Double, direction: Direction) -> Expression {
        return Expression(self.operations + [.Binary(value: value, function: function, direction: direction)])
    }
    
    func composeWith(function function: (Double) -> Double) -> Expression {
        return Expression(self.operations + [.Unary(function: function)])
    }
    
    //    func evaluate<Interval: IntervalType>(#interval: Interval, step: Interval.Element) -> Domain {
    //        return Domain()
    //    }
    
}

// MARK: - Binary functions

// MARK: Arithmetic functions

public func +(lhs: Expression, rhs: Double) -> Expression {
    return lhs.composeWith(value: rhs, function: +, direction: .ExprThenValue)
}

public func +(lhs: Double, rhs: Expression) -> Expression {
    return rhs.composeWith(value: lhs, function: +, direction: .ValueThenExpr)
}

public func -(lhs: Expression, rhs: Double) -> Expression {
    return lhs.composeWith(value: rhs, function: -, direction: .ExprThenValue)
}

public func -(lhs: Double, rhs: Expression) -> Expression {
    return rhs.composeWith(value: lhs, function: -, direction: .ValueThenExpr)
}

public func *(lhs: Expression, rhs: Double) -> Expression {
    return lhs.composeWith(value: rhs, function: *, direction: .ExprThenValue)
}

public func *(lhs: Double, rhs: Expression) -> Expression {
    return rhs.composeWith(value: lhs, function: *, direction: .ValueThenExpr)
}

public func /(lhs: Expression, rhs: Double) -> Expression {
    return lhs.composeWith(value: rhs, function: /, direction: .ExprThenValue)
}

public func /(lhs: Double, rhs: Expression) -> Expression {
    return rhs.composeWith(value: lhs, function: /, direction: .ValueThenExpr)
}

// MARK: Algebraic functions

public func pow(lhs: Expression, _ rhs: Double) -> Expression {
    return lhs.composeWith(value: rhs, function: pow, direction: .ExprThenValue)
}

public func pow(lhs: Double, _ rhs: Expression) -> Expression {
    return rhs.composeWith(value: lhs, function: pow, direction: .ValueThenExpr)
}

infix operator ** { associativity left precedence 160 }

public func **(lhs: Expression, rhs: Double) -> Expression {
    return pow(lhs, rhs)
}

public func **(lhs: Double, rhs: Expression) -> Expression {
    return pow(lhs, rhs)
}

// MARK: - Unary functions

// MARK: Factorial function

public let factorial = memoize(_factorial)

private func _factorial(x: Int) -> Double {
    precondition(x >= 0, "Factorial is undefined for negative numbers")
    var result = 1.0
    for var i = Double(x); i > 1; i-- {
        result *= i
    }
    return result
}

public func factorial(x: Double) -> Double {
    return factorial(Int(x))
}

public func factorial(x: Expression) -> Expression {
    return x.composeWith(function: factorial)
}

// MARK: Trigonometric functions

public func cos(x: Expression) -> Expression {
    return x.composeWith(function: cos)
}

public func sin(x: Expression) -> Expression {
    return x.composeWith(function: sin)
}

public func tan(x: Expression) -> Expression {
    return x.composeWith(function: tan)
}

public func acos(x: Expression) -> Expression {
    return x.composeWith(function: acos)
}

public func asin(x: Expression) -> Expression {
    return x.composeWith(function: asin)
}

public func atan(x: Expression) -> Expression {
    return x.composeWith(function: atan)
}

// MARK: Hyperbolic functions

public func cosh(x: Expression) -> Expression {
    return x.composeWith(function: cosh)
}

public func sinh(x: Expression) -> Expression {
    return x.composeWith(function: sinh)
}

public func tanh(x: Expression) -> Expression {
    return x.composeWith(function: tanh)
}

public func acosh(x: Expression) -> Expression {
    return x.composeWith(function: acosh)
}

public func asinh(x: Expression) -> Expression {
    return x.composeWith(function: asinh)
}

public func atanh(x: Expression) -> Expression {
    return x.composeWith(function: atanh)
}
