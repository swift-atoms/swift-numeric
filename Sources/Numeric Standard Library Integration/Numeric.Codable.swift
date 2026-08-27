public import Numeric

#if !hasFeature(Embedded)
    extension Numeric.Sign: Codable {}

    extension Numeric.Ternary: Codable {}

    extension Numeric.Rounding: Codable {}

    extension Numeric.Rounding.Direction: Codable {}

    extension Numeric.Rounding.Nearest: Codable {}
#endif
