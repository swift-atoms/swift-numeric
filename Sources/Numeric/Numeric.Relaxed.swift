extension Numeric {

    /// Legacy arithmetic permitting ordinary Swift evaluation without a fusion guarantee.
    /// This implementation evaluates multiply-add as a rounded product followed by a sum.
    public enum Relaxed {}
}

extension Numeric.Relaxed {

    @inlinable
    public static func sum(_ a: Double, _ b: Double) -> Double {
        a + b
    }

    @inlinable
    public static func product(_ a: Double, _ b: Double) -> Double {
        a * b
    }

    @inlinable
    public static func multiplyAdd(_ a: Double, _ b: Double, _ c: Double) -> Double {
        c + a * b
    }
}

extension Numeric.Relaxed {

    @inlinable
    public static func sum(_ a: Float, _ b: Float) -> Float {
        a + b
    }

    @inlinable
    public static func product(_ a: Float, _ b: Float) -> Float {
        a * b
    }

    @inlinable
    public static func multiplyAdd(_ a: Float, _ b: Float, _ c: Float) -> Float {
        c + a * b
    }
}
