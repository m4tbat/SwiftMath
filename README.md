#SwiftMath

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

SwiftMath is a Swift microframework providing some useful math constructs and functions, like complex numbers, 3D vectors, quaternions, and polynomial equation solving.

⚠️ *SwiftMath is work in progress. Master is currently targeting Swift 2.0 (beta3).
For Swift 1.2 compatibility checkout the release [0.1.1](https://github.com/madbat/SwiftMath/releases/tag/v0.1.1)*

##Requirements

SwiftMath requires iOS 8.0+ / OS X 10.9+.

##Installation

SwiftMath can be installed through the dependency manager [Carthage](https://github.com/Carthage/Carthage).
*	Add the following line to your project's Cartfile
```
github "madbat/SwiftMath"
```
*	In the terminal, run `carthage update`
*	Link your project target(s) with the built frameworks. Application targets should also ensure that the framework gets copied into their application bundle. 

##Usage

###VectorR3

VectorR3 — as the name suggests — represents a vector in the three-dimensional Euclidean space (aka R×R×R).
Some of the most common uses of 3D vectors consist in encoding physical quantities like position, velocity, acceleration, force, and many others.

```swift
let v1 = VectorR3(x: 1, y: 2, z: 3)
let v2 = VectorR3(x: 5, y: 6, z: 7)

// vector sum
let v3 = v1 + v2 // VectorR3(x: 6, y: 8, z: 10)

// length
v3.length // equals v3.norm

// zero vector
Vector.zero() // VectorR3(x: 0, y: 0, z: 0)

// unit-length vector
v3.unit() // divides v3 by its length
```

###Complex

Complex numbers extend real numbers in order to solve problems that cannot be solved with real numbers alone.
For example, the roots of a polynomial equation of degree > 1 can always be expressed with complex numbers, but not with real numbers.

```swift
// the default constructor for Complex takes the real and imaginary parts as parameters
let c1 = Complex(1.0, 3.0)
c1.re // 1.0
c1.im // 3.0

// a complex can also be constructed by using the property i defined on Float and Double
let c2 = 5 + 1.i // Complex(5.0, 1.0)

// complex conjugate
c2.conj() // Complex(5.0, -1.0)

// polar form
let c3 = Complex(abs: 2.0, arg: -4.0)

let realComplex = Complex(10.0, 0.0)
realComplex.isReal // true
```

###Quaternion

Quaternions extend complex numbers to 4 dimensions.
They're handy to rotate three-dimensional vectors.

```swift
// rotating a vector by π/2 around its x axis
let original = VectorR3(x: 3, y: 4, z: 0)
let rotation = Quaternion(axis: VectorR3(x: 1, y: 0, z: 0), angle: Double.PI/2.0)
let rotated = original.rotate(rotation) // VectorR3(x: 3, y: 0, z: 4.0)
```

###Polynomials

SwiftMath provides functions to find (complex) roots of polynomials, by analytic and numeric means:
-	`linear`: analytically find roots of a polynomial of degree 1
-	`quadratic`: analytically find roots of a polynomial of degree 2
-	`cubic`: analytically find roots of a polynomial of degree 3
-	`quartic`: analytically find roots of a polynomial of degree 4
-	`polynomial`: find roots of a polynomial of degree equal to the number of passed-in arguments, minus 1. If degree <= 4, defaults to using the analytic method (by calling one of the above functions), while if `preferClosedFormSolution: false`, or degree > 4, uses the the [Durand-Kerner method](http://en.wikipedia.org/wiki/Durand%E2%80%93Kerner_method).

```swift
// The roots of a polynomial are represented as a (multi)set of complex numbers
var roots: Multiset<Complex<Double>>
// x + 3 = 0
roots = linear(1, 3) // roots contains (-3 + 0.i)
// x^2 + 2x + 1 = 0
roots = quadratic(1, 2, 1) // roots contains (-1 + 0.i) with a multiplicity of 2
// x^3 + x^2 + x + 1 = 0
roots = cubic(1, 1, 1, 1) // roots contains (-1 + 0.i, 1.i, -1.i)
// x^4 + x^3 + x^2 + x = 0
roots = quartic(1, 1, 1, 1, 0) // roots contains (0.i, -1 + 0.i, -1.i, 1.i)
// the polynomial function can be used in place of the above functions
roots = polynomial([1, 1, 1, 1, 0]) // is equivalent to quartic(1, 1, 1, 1, 0)
// the polynomial function has the ability to use a numeric method instead of the analytic one
roots = polynomial(preferClosedFormSolution: false, [1, 1, 1, 1, 0]) // roots will be a very close approximation to the analytic ones
// for polynomials of degree > 4, polynomial can only use the numeric method
roots = polynomial([1, -5, 2.3, 0, 42, -0.8]) // will solve numerically the polynomial x^5 - 5x^4 + 2.3x^3 + 42x - 0.8 = 0

```

##Contributing

Contributions in any form (especially pull requests) are _very_ welcome!

##License

SwiftMath is released under the MIT License. See the [LICENSE](https://github.com/madbat/SwiftMath/blob/master/LICENSE) file for more info.
