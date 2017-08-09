# SwiftMath

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

SwiftMath is a Swift framework providing some useful math constructs and functions, like complex numbers, vectors, matrices, quaternions, and polynomials.

:warning: *SwiftMath is work in progress, in alpha state. Master is currently targeting Swift 2.1.*

## Requirements

SwiftMath requires iOS 8.0+ / OS X 10.9+.

## Installation

SwiftMath can be installed with the dependency manager [Carthage](https://github.com/Carthage/Carthage).
*	Add the following line to your project's Cartfile
```
github "madbat/SwiftMath"
```
*	In the terminal, run `carthage update`
*	Link your project target(s) with the built frameworks. Application targets should also ensure that the framework gets copied into their application bundle.

## Usage

### Vector3

Vector3 — as the name suggests — represents a vector in the three-dimensional Euclidean space (aka R×R×R).
Some of the most common uses of 3D vectors consist in encoding physical quantities like position, velocity, acceleration, force, and many others.

```swift
let v1 = Vector3(x: 1, y: 2, z: 3)
let v2 = Vector3(x: 5, y: 6, z: 7)

// vector sum
let v3 = v1 + v2 // Vector3(x: 6, y: 8, z: 10)

// length
v3.length // equals v3.norm

// zero vector
Vector3.zero() // Vector3(x: 0, y: 0, z: 0)

// unit-length vector
v3.unit() // divides v3 by its length
```

### Vector2

Pretty much like `Vector3`, but for 2D vectors.

### Complex

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

### Quaternion

Quaternions extend complex numbers to 4 dimensions.
They're handy to rotate three-dimensional vectors.

```swift
// rotating a vector by π/2 around its x axis
let original = Vector3(x: 3, y: 4, z: 0)
let rotation = Quaternion(axis: Vector3(x: 1, y: 0, z: 0), angle: Double.PI/2.0)
let rotated = original.rotate(rotation) // Vector3(x: 3, y: 0, z: 4.0)
```

### Polynomial

Polynomial lets you represent – and find the roots of – a polynomial expression.

The following snippet shows how to express the polynomial `x^2 + 4x + 8`
```swift
let p = Polynomial(1, 4, 8)
```

Use Polynomial's `roots()` method to calculate its roots, represented as a (multi)set of complex numbers:
```swift
p.roots() // returns { (-2 - 2i), (-2 + 2i) }
```
For polynomials of degree <= 4, `roots()` defaults to using the analytic method, while for polynomials of higher degrees it uses the the [Durand-Kerner method](http://en.wikipedia.org/wiki/Durand%E2%80%93Kerner_method).
It is possible to force the root finding process to use the numeric method also for polynomials
of degree <= 4, using `roots(preferClosedFormSolution: false)`.

## Contributing

Contributions in any form (especially pull requests) are _very_ welcome!

## License

SwiftMath is released under the MIT License. See the [LICENSE](https://github.com/madbat/SwiftMath/blob/master/LICENSE) file for more info.
