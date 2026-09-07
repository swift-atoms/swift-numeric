public import Addition
public import Multiplication

extension Numeric {
    /// Compatibility vocabulary. New code uses Addition and Multiplication directly.
    public enum Augmented {}
}

extension Numeric.Augmented {
    @inlinable
    public static func product<T: FloatingPoint>(_ a: T, _ b: T) -> (head: T, tail: T) {
        Multiplication.augmented(a, b)
    }

    @inlinable
    public static func sum<T: FloatingPoint>(_ a: T, _ b: T) -> (head: T, tail: T) {
        Addition.augmented(a, b)
    }

    @inlinable
    public static func sum<T: FloatingPoint>(large: T, small: T) -> (head: T, tail: T) {
        Addition.augmented(large: large, small: small)
    }
}
