#SwiftMath

SwiftMath is a Swift microframework providing some useful math constructs and functions, like complex numbers, 3D vectors, quaternions, and polynomial equation solving.

##Usage

###VectorR3

VectorR3 — as the name suggests — represents a vector in the three-dimensional Euclidean space (aka R×R×R).
Some of the most common uses of 3D vectors consist in encoding physical quantities like position, velocity, acceleration, force, and many others.

###Complex

Complex numbers extend real numbers in order to solve problems that cannot be solved with real numbers alone.
For example, the roots of a polynomial equation of degree > 1 can always be expressed with complex numbers, but not with real numbers.

###Quaternion

Quaternions extend complex numbers to 4 dimensions.
They're handy to rotate three-dimensional vectors.

###Polynomials

SwiftMath provides functions to find roots of polynomials, both analytic – the `linear`, `quadratic`, `cubic`, `quartic` functions or the more general `polynomial` function – and numeric (using the Durand-Kerner method) – `polynomial`, specifying `preferClosedFormSolution: false` if the degree of the polynomial is < 5.
