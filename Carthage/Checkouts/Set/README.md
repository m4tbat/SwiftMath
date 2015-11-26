# Set

[![Build status](https://api.travis-ci.org/robrix/Set.svg)](https://travis-ci.org/robrix/Set)

This is a Swift microframework which implements a PredicateSet and a Dictionary-backed Multiset.

## Use
Multiset:
```swift
// Union
Multiset(1, 2, 3) + Multiset(3, 4, 5) // == Multiset(1, 2, 3, 3, 4, 5)

// Difference
Multiset(1, 2, 3) - Multiset(2, 3) // == Multiset(1)

// Intersection
Multiset(1, 2, 3) & Multiset(3, 4, 5) // == Multiset(3)
```
PredicateSet:
```swift
// Union
let union = PredicateSet { $0 > 0 } + PredicateSet { $0 % 2 == 0 }
union.contains(3) // true

// Difference
let difference = PredicateSet { $0 > 0 } - PredicateSet { $0 % 2 == 0 }
difference.contains(6) // false

// Special Sets
func isInt(number: Float) -> Bool {
	return Float(Int(number)) == number
}

let Q: PredicateSet<Float> = PredicateSet { _ in true } // Set of all real numbers.
let Z = Q & PredicateSet { isInt($0) } // Set of all integers.
let N = Z & PredicateSet { $0 > 0 } // Set of all natural numbers.

N.contains(1) // true
N.contains(-1.5) // false
```
See [`Multiset.swift`][Multiset.swift] and [`PredicateSet.swift`][PredicateSet.swift] for more details.

## Integration

1. Add this repo as a submodule in e.g. `External/Set`:
  
        git submodule add https://github.com/robrix/Set.git External/Set
2. Drag `Set.xcodeproj` into your `.xcworkspace`/`.xcodeproj`.
3. Add `Set.framework` to your target’s `Link Binary With Libraries` build phase.
4. You may also want to add a `Copy Files` phase which copies `Set.framework` (and any other framework dependencies you need) into your bundle’s `Frameworks` directory. If your target is a framework, you may instead want the client app to include `Set.framework`.

## Thanks

- [Greg Titus wrote a Set in Swift which inspired this](https://twitter.com/gregtitus/status/476420154230726656).
- The Swift team at Apple added a `Set` type to the standard library in Swift 1.2, which reduced our support load considerably.

[Multiset.swift]: https://github.com/robrix/Set/blob/master/Set/Multiset.swift
[PredicateSet.swift]: https://github.com/robrix/Set/blob/master/Set/PredicateSet.swift
