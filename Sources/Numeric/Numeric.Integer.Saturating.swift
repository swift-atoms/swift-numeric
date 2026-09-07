public import Addition
public import Subtraction
public import Multiplication

extension Numeric.Integer {

    public struct Saturating<T: FixedWidthInteger> {
        @usableFromInline
        let value: T

        @usableFromInline
        internal init(_ value: T) {
            self.value = value
        }
    }
}

extension Numeric.Integer.Saturating: Swift.Sendable where T: Swift.Sendable {}

extension Numeric.Integer.Saturating {
    @inlinable public func add(_ other: T) -> T { Addition.saturating(value, other) }
    @inlinable public func subtract(_ other: T) -> T { Subtraction.saturating(value, other) }
    @inlinable public func multiply(by other: T) -> T { Multiplication.saturating(value, other) }
    @inlinable public func negate() -> T where T: SignedInteger { Subtraction.saturating(0, value) }
}
