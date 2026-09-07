extension Swift.SignedNumeric where Self: Sendable {

    @inlinable
    public var equals: Numeric.Comparison.Equals<Self> {
        Numeric.Comparison.Equals(self)
    }
}
