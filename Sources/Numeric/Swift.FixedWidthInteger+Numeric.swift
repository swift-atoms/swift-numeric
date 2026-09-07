extension Swift.FixedWidthInteger where Self: Sendable {

    @inlinable
    public var rotation: Numeric.Integer.Rotation<Self> {
        Numeric.Integer.Rotation(self)
    }
}

extension Swift.FixedWidthInteger where Self: Sendable {

    @inlinable
    public var saturating: Numeric.Integer.Saturating<Self> {
        Numeric.Integer.Saturating(self)
    }
}
