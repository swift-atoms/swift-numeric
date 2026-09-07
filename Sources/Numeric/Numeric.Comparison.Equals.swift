extension Numeric.Comparison {

    public struct Equals<T> {
        @usableFromInline
        let value: T

        @usableFromInline
        internal init(_ value: T) {
            self.value = value
        }
    }
}

extension Numeric.Comparison.Equals: Swift.Sendable where T: Swift.Sendable {}

extension Numeric.Comparison.Equals where T: FloatingPoint {

    @inlinable
    public func approximate(_ other: T, tolerance: T) -> Bool {
        (value - other).magnitude <= tolerance
    }

    @inlinable
    public func approximate(_ other: T, absolute: T, relative: T = .zero) -> Bool {
        let diff = (value - other).magnitude
        let scale = Swift.max(value.magnitude, other.magnitude)
        return diff <= absolute + relative * scale
    }
}

extension Numeric.Comparison.Equals where T: SignedNumeric, T.Magnitude: Comparable {

    @inlinable
    public func approximate(_ other: T, tolerance: T.Magnitude) -> Bool {
        (value - other).magnitude <= tolerance
    }
}
