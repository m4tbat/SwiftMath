//  Copyright (c) 2015 Rob Rix. All rights reserved.

/// Describes a sequence as a set.
internal func describe<S: SequenceType>(sequence: S) -> String {
	return mapDescription(sequence, toString)
}

/// Debug-describes a sequence as a set.
internal func debugDescribe<S: SequenceType>(sequence: S) -> String {
	return mapDescription(sequence, toDebugString)
}


/// Maps the elements of `sequence` with `transform` and formats them as a set.
private func mapDescription<S: SequenceType>(sequence: S, transform: S.Generator.Element -> String) -> String {
	return wrapDescription(join(", ", lazy(sequence).map(transform)))
}

/// Wraps a string appropriately for formatting as a set.
private func wrapDescription(description: String) -> String {
	return description.isEmpty ?
		"{}"
	:	"{\(description)}"
}
