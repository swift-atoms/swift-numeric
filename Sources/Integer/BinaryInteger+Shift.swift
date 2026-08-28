import Numeric

extension BinaryInteger {

    @inlinable
    public var shifted: Numeric.Integer.Shift<Self> {
        Numeric.Integer.Shift(self)
    }
}
