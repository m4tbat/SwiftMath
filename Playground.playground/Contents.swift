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

//let x = Expression()
//
//let expression = sin(x)
//
//expression.evaluateFor(Double.PI/2)
//
//for i in (-100..<100) {
//    expression.evaluateFor(Double(i)*0.1)
//}
//

//extension Array where Element: Float {
//    func f() -> Element {
//        return 3.0
//    }
//}
//
//extension Array where Element: Double {
//    func f() -> Element {
//        return 3.0
//    }
//}

let po: Double = 0.0

func vec<T: RealType>(elem: T) -> [T] {
    return [1.0, 5.0, 2.0]
}

let x = [1.1, 2.0, 5.0]
let y = [3.0, -4.0, 0.0]

clip(x, 1.1, 2.0)
x.thresholdValues(3)

add(vec(1.0), vec(2.0))


