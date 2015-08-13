//: Playground - noun: a place where people can play

import SwiftMath
import Set

let p = Polynomial(1, 4, 8)

p.roots()

let v1 = Vector3(x: 10, y: 20, z: 5)
let v2 = Vector3(x: 10, y: 5, z: 20)

v1.crossProduct(v2)


let v5a: Vector = [1, 1, 1, 1, 1]
let v5b: Vector = [2, 2, 2, 2, 2]

(v5a + v5b).coordinates

v5b.squareLength

let f = factorial(100)

let x = Expression()

let expression = sin(x)

expression.evaluateFor(Double.PI/2)

for i in (-100..<100) {
    expression.evaluateFor(Double(i)*0.1)
}

