//: Playground - noun: a place where people can play

import SwiftMath
import Set
import Accelerate

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

x.threshold(3)

add(vec(1.0), vec(2.0))

func rango(x: Matrix<Float>) -> Int {
    var results = x
    
    var nr = __CLPK_integer(x.order.rows)
    var nc = __CLPK_integer(x.order.columns)
    var lwork = __CLPK_integer(10*max(nr, nc))
    var work = [__CLPK_real](count: Int(lwork), repeatedValue: 0.0)
    var error: __CLPK_integer = 0
    let lds = max(nr, nc)
    var s = [__CLPK_real](count: Int(lds), repeatedValue: 0.0)
    var u = [__CLPK_real](count: Int(nr * nr), repeatedValue: 0.0)
    var vt = [__CLPK_real](count: Int(nc), repeatedValue: 0.0)
    
    var jobu: Int8 = 78 // 'N'
    var jobvt: Int8 = 78 // 'N'
    
    sgesvd_(&jobu, &jobvt, &nr, &nc, &(results.grid), &nc, &s, &u, &nr, &vt, &nc, &work, &lwork, &error)
    
    print(s)
    
    let epsilon: Float = 1e-4
    return s.lazy.filter { $0 > epsilon }.count
}

let m: Matrix<Float> = Matrix([1.0, 2.0, 3.0], [2.0, 2.0, 2.0], [3.0, 4.0, 5.0])

rango(m)

