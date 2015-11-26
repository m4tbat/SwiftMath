//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Describes a sequence as a set.
internal func describe<S: SequenceType>(sequence: S) -> String {
	return mapDescription(sequence, transform: toString)
}

/// Debug-describes a sequence as a set.
internal func debugDescribe<S: SequenceType>(sequence: S) -> String {
	return mapDescription(sequence, transform: toDebugString)
}

/// Maps the elements of `sequence` with `transform` and formats them as a set.
private func mapDescription<S: SequenceType>(sequence: S, transform: S.Generator.Element -> String) -> String {
	return wrapDescription(sequence.lazy.map(transform).joinWithSeparator(", "))
}

/// Wraps a string appropriately for formatting as a set.
private func wrapDescription(description: String) -> String {
	return description.isEmpty ?
		"{}"
	:	"{\(description)}"
}

// Returns the result of `print`ing x into a `String`
private func toString<T>(x: T) -> String {
	return String(x)
}

// Returns the result of `debugPrint`ing x into a `String`
private func toDebugString<T>(x: T) -> String {
	return String(reflecting: x)
}
