//: Playground - noun: a place where people can play

import UIKit
import SwiftMath
import Set

let p = Polynomial(1, 4, 8)

p.roots()

let v1 = Vector3(x: 10, y: 20, z: 5)
let v2 = Vector3(x: 10, y: 5, z: 20)

v1.crossProduct(v2)

var set: Set = [2,3,4]

set.insert(3)

set.remove(3)

set

var multiset: Multiset = [2,3,4]

multiset.insert(3)

multiset

let v5a: Vector = [1, 1, 1, 1, 1]
let v5b: Vector = [2, 2, 2, 2, 2]

(v5a + v5b).coordinates

v5b.squareLength

//struct Domain: CollectionType {
//    
//}

struct Expression {
    
    typealias Operation = (value: Double, function: (Double, Double) -> Double)
    
    var operations: [Operation] = []
    
    init() {
        
    }
    
    init(_ operations: [Operation]) {
        self.operations = operations
    }
    
    func evaluateFor(value: Double) -> Double {
        return operations.reduce(value) { (acc: Double, operation: Operation) -> Double in
            operation.function(acc, operation.value)
        }
    }
    
//    func evaluate<Interval: IntervalType>(#interval: Interval, step: Interval.Element) -> Domain {
//        return Domain()
//    }

}

func +(lhs: Double, rhs: Expression) -> Expression {
    return Expression(rhs.operations + [(lhs, +)])
}

func +(lhs: Expression, rhs: Double) -> Expression {
    return Expression(lhs.operations + [(rhs, +)])
}

func *(lhs: Double, rhs: Expression) -> Expression {
    return Expression(rhs.operations + [(lhs, *)])
}

func *(lhs: Expression, rhs: Double) -> Expression {
    return Expression(lhs.operations + [(rhs, *)])
}

infix operator ^ { associativity left precedence 160 }
func ^(lhs: Expression, rhs: Double) -> Expression {
    return Expression(lhs.operations + [(rhs, pow)])
}

let x = Expression()

let expression: Expression = 5.0*x^3.0 + 4.0

expression.evaluateFor(2.0)

(-100..<100).map { (i: Int) -> () in
    expression.evaluateFor(Double(i))
    return ()
}

