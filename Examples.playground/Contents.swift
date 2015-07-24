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
