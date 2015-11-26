//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// A multiset of elements and their counts.
public struct Multiset<Element: Hashable>: ArrayLiteralConvertible, Hashable, CustomStringConvertible, CustomDebugStringConvertible, CollectionType {
	// MARK: Constructors

	/// Constructs a `Multiset` with the elements of `sequence`.
	public init<S: SequenceType where S.Generator.Element == Element>(_ sequence: S) {
		self.init(values: [:])
		extend(sequence)
	}

	/// Constructs a `Multiset` from a variadic parameter list.
	public init(_ elements: Element...) {
		self.init(elements)
	}

	/// Constructs the empty `Multiset`.
	public init() {
		self.init(values: [:])
	}

	/// Constructs an empty `Multiset` with a hint as to the capacity it should allocate.
	public init(minimumCapacity: Int) {
		self.init(values: [Element: Int](minimumCapacity: minimumCapacity))
	}


	// MARK: Properties

	/// The number of entries in the receiver.
	public var count: Int {
		return values.values.reduce(0, combine: +)
	}

	/// The number of distinct entries in the receiver.
	public var countDistinct: Int {
		return values.count
	}

	/// True iff `count` is 0.
	public var isEmpty: Bool {
		return values.isEmpty
	}


	// MARK: Primitive operations

	/// True iff `element` is in the receiver, as defined by its hash and equality.
	public func contains(element: Element) -> Bool {
		return count(element) > 0
	}

	/// Returns the number of occurrences of `element` in the receiver.
	public func count(element: Element) -> Int {
		return values[element] ?? 0
	}

	/// Inserts `element` into the receiver.
	public mutating func insert(element: Element) {
		values[element] = (values[element] ?? 0) + 1
	}

	/// Removes `element` from the receiver.
	public mutating func remove(element: Element) {
		if let value = values[element] where value > 1 {
			values[element] = value - 1
		} else {
			values.removeValueForKey(element)
		}
	}

	/// Removes all elements from the receiver, optionally maintaining its capacity (defaulting to false).
	public mutating func removeAll(keepCapacity: Bool = false) {
		values.removeAll(keepCapacity: keepCapacity)
	}


	// MARK: Algebraic operations

	/// Returns the union of the receiver and `set`.
	public func union(set: Multiset) -> Multiset {
		return self + set
	}

	/// Returns the intersection of the receiver and `set`.
	public func intersection(set: Multiset) -> Multiset {
		return Multiset(values: countDistinct <= set.countDistinct ?
			values.map { ($0, min($1, set.count($0))) }
		:	set.values.map { ($0, min($1, self.count($0))) })
	}

	/// Returns the relative complement of `set` in `self`.
	///
	/// This is a new set with all elements from the receiver which are not contained in `set`.
	public func complement(set: Multiset) -> Multiset {
		return Multiset(values: values.lazy.map { ($0, $1 - set.count($0)) })
	}

	/// Returns the symmetric difference of `self` and `set`.
	///
	/// This is a new set with all elements that exist only in `self` or `set`, and not both.
	public func difference(set: Multiset) -> Multiset {
		return (set - self) + (self - set)
	}


	// MARK: Inclusion functions

	/// True iff the receiver is a subset of (is included in) `set`.
	public func subset(set: Multiset) -> Bool {
		return complement(set) == Multiset()
	}

	/// True iff the receiver is a subset of but not equal to `set`.
	public func strictSubset(set: Multiset) -> Bool {
		return subset(set) && self != set
	}

	/// True iff the receiver is a superset of (includes) `set`.
	public func superset(set: Multiset) -> Bool {
		return set.subset(self)
	}

	/// True iff the receiver is a superset of but not equal to `set`.
	public func strictSuperset(set: Multiset) -> Bool {
		return set.strictSubset(self)
	}


	// MARK: Higher-order functions

	/// Returns a new set including only those elements `x` where `includeElement(x)` is true.
	public func filter(includeElement: Element -> Bool) -> Multiset {
		return Multiset(self.lazy.filter(includeElement))
	}

	/// Returns a new set with the result of applying `transform` to each element.
	public func map<Result>(transform: Element -> Result) -> Multiset<Result> {
		return flatMap { [transform($0)] }
	}

	/// Applies `transform` to each element and returns a new set which is the union of each resulting set.
	public func flatMap<Result, S: SequenceType where S.Generator.Element == Result>(transform: Element -> S) -> Multiset<Result> {
		return reduce([]) { $0 + transform($1) }
	}

	/// Combines each element of the receiver with an accumulator value using `combine`, starting with `initial`.
	public func reduce<Into>(initial: Into, _ combine: (Into, Element) -> Into) -> Into {
		return reduce(initial, combine: combine)
	}


	// MARK: ArrayLiteralConvertible

	public init(arrayLiteral elements: Element...) {
		self.init(elements)
	}


	// MARK: SequenceType

	public typealias Generator = AnyGenerator<Element>

	public func generate() -> Generator {
		var generator = values.generate()
		let next = { generator.next() }
		var current: (element: Element?, count: Int) = (nil, 0)
		return anyGenerator {
			while current.count <= 0 {
				if let (element, count) = next() {
					current = (element, count)
					break
				}
				else { return nil }
			}
			--current.count
			return current.element
		}
	}


	// MARK: CollectionType

	public typealias Index = MultisetIndex<Element>

	public var startIndex: Index {
		return MultisetIndex(from: values.startIndex, delta: 0, max: count)
	}

	public var endIndex: Index {
		return MultisetIndex(from: values.endIndex, delta: 0, max: count)
	}

	public subscript(index: Index) -> Element {
		let (element, count) = values[index.from]
		if index.delta > (count - 1) {
			return self[MultisetIndex(from: index.from.successor(), delta: index.delta - count, max: self.count)]
		} else {
			return element
		}
	}


	// MARK: ExtensibleCollectionType

	/// In theory, reserve capacity for `n` elements. However, `Dictionary` does not implement `reserveCapacity`, so we just silently ignore it.
	public func reserveCapacity(n: Multiset.Index.Distance) {}

	/// Inserts each element of `sequence` into the receiver.
	public mutating func extend<S: SequenceType where S.Generator.Element == Element>(sequence: S) {
		// Note that this should just be for each in sequence; this is working around a compiler bug.
		for each in AnySequence<Element>(sequence) {
			insert(each)
		}
	}

	/// Appends `element` onto the `Multiset`.
	public mutating func append(element: Element) {
		insert(element)
	}


	// MARK: Hashable

	/// Hashes using Bob Jenkins’ one-at-a-time hash.
	///
	/// http://en.wikipedia.org/wiki/Jenkins_hash_function#one-at-a-time
	///
	/// NB: Jenkins’ usage appears to have been string keys; the usage employed here seems similar but may have subtle differences which have yet to be discovered.
	public var hashValue: Int {
		return hashValues(self)
	}


	// MARK: CustomStringConvertible

	public var description: String {
		return describe(self)
	}


	// MARK: CustomDebugStringConvertible

	public var debugDescription: String {
		return debugDescribe(self)
	}


	// MARK: Private

	/// Constructs a `Multiset` with a dictionary of `values`.
	private init(values: [Element: Int]) {
		self.values = values
	}

	/// Constructs a `Multiset` with a sequence of element/count pairs.
	private init<S: SequenceType where S.Generator.Element == Dictionary<Element, Int>.Element>(values: S) {
		self.values = [:]
		for (element, count) in values {
			if count > 0 { self.values[element] = count }
		}
	}

	/// Counts indexed by value.
	private var values: Dictionary<Element, Int>
}


// MARK: - Operators

/// Returns a new set with all elements from `set` and `other`.
public func + <Element, S: SequenceType where S.Generator.Element == Element> (var set: Multiset<Element>, other: S) -> Multiset<Element> {
	for element in other {
		set.insert(element)
	}
	return set
}

/// Extends a `set` with the elements of a `sequence`.
public func += <S: SequenceType> (inout set: Multiset<S.Generator.Element>, sequence: S) {
	set.extend(sequence)
}


/// Returns a new set with all elements from `set` which are not contained in `other`.
public func - <Element> (set: Multiset<Element>, other: Multiset<Element>) -> Multiset<Element> {
	return set.complement(other)
}

/// Removes all elements in `other` from `set`.
public func -= <Element> (inout set: Multiset<Element>, other: Multiset<Element>) {
	set = set.complement(other)
}


/// Intersects with `set` with `other`.
public func &= <Element> (inout set: Multiset<Element>, other: Multiset<Element>) {
	set = set.intersection(other)
}

/// Returns the intersection of `set` and `other`.
public func & <Element> (set: Multiset<Element>, other: Multiset<Element>) -> Multiset<Element> {
	return set.intersection(other)
}


// Defines equality for multisets.
public func == <Element> (a: Multiset<Element>, b: Multiset<Element>) -> Bool {
	return a.values == b.values
}


/// The index for values of a multiset.
public struct MultisetIndex<Element: Hashable>: ForwardIndexType, Comparable {
	// MARK: ForwardIndexType

	public func successor() -> MultisetIndex {
		return MultisetIndex(from: from, delta: delta + 1, max: max)
	}


	// MARK: Private

	private let from: DictionaryIndex<Element, Int>
	private let delta: Int
	private let max: Int
}


// MARK: Equatable

public func == <Element: Hashable> (left: MultisetIndex<Element>, right: MultisetIndex<Element>) -> Bool {
	if left.from == right.from {
		return left.delta == right.delta && left.max == right.max
	} else {
		return left.max == right.max && abs(left.delta - right.delta) == left.max
	}
}


// MARK: Comparable

public func < <Element: Hashable> (left: MultisetIndex<Element>, right: MultisetIndex<Element>) -> Bool {
	if left.from == right.from {
		return left.delta < right.delta
	} else if left.from < right.from {
		return (left.delta - right.delta) < left.max
	}
	return false
}


