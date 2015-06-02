//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// A set of elements of type T expressed mathematically as:
/// { 𝑥 ∈ T | proposition(𝑥) }.
public struct PredicateSet<Element: Hashable> {
	// MARK: Constructors
	
	/// Constructs an empty `PredicateSet`.
	public init() {
		predicate = { _ in false }
	}
	
	/// Constructs a `PredicateSet` from a boolean predicate.
	public init(_ predicate: Element -> Bool) {
		self.predicate = predicate
	}
		
	/// Constructs a `PredicateSet` from a `Set`.
	public init(_ set: Set<Element>) {
		predicate = { set.contains($0) }
	}
	
	/// Constructs a `PredicateSet` from a `Multiset`.
	public init(_ set: Multiset<Element>) {
		predicate = { set.contains($0) }
	}
	
	
	// MARK: Properties
	
	/// The set's predicate.
	private let predicate: Element -> Bool
	
	
	// MARK: Primitive operations
	
	/// True iff predicate is true for `element`. (In other words, whether `element` is contained within the possibly infinite PredicateSet.)
	public func contains(element: Element) -> Bool {
		return predicate(element)
	}
	
	
	// MARK: Algebraic operations
	
	/// Returns the union of the receiver and `set`.
	public func union(set: PredicateSet) -> PredicateSet {
		return PredicateSet { self.predicate($0) || set.contains($0) }
	}
	
	/// Returns the intersection of the receiver and `set`.
	public func intersection(set: PredicateSet) -> PredicateSet {
		return PredicateSet { self.predicate($0) && set.contains($0) }
	}
	
	/// Returns the relative complement of the receiver and `set`.
	public func complement(set: PredicateSet) -> PredicateSet {
		return PredicateSet { self.predicate($0) && !set.contains($0) }
	}
	
	/// Returns the symmetric difference of the receiver and `set`.
	public func difference(set: PredicateSet) -> PredicateSet {
		return PredicateSet { !(self.predicate($0) && set.contains($0)) }
	}
}


// MARK: - Operators

/// Returns the union of `lhs` and `rhs`.
public func +<T>(lhs: PredicateSet<T>, rhs: PredicateSet<T>) -> PredicateSet<T> {
	return lhs.union(rhs)
}

/// Returns the symmetric difference of `lhs` and `rhs`.
public func -<T>(lhs: PredicateSet<T>, rhs: PredicateSet<T>) -> PredicateSet<T> {
	return lhs.difference(rhs)
}

/// Returns the intersection of `lhs` and `rhs`.
public func &<T>(lhs: PredicateSet<T>, rhs: PredicateSet<T>) -> PredicateSet<T> {
	return lhs.intersection(rhs)
}
