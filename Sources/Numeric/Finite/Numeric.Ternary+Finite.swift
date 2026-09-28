#if Finite
public import Cardinal
public import Finite
public import Index
public import Ordinal
public import Tagged

extension Numeric.Ternary: Finite.Enumerable {

    @inlinable
    public static var count: Cardinal { Cardinal(UInt(3)) }

    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .negative: Ordinal(UInt(0))
        case .zero: Ordinal(UInt(1))
        case .positive: Ordinal(UInt(2))
        }
    }

    @inlinable
    public init(_unchecked: Void, ordinal: Ordinal) {
        switch ordinal.rawValue {
        case 0: self = .negative
        case 1: self = .zero
        case 2: self = .positive
        default: preconditionFailure("Numeric.Ternary ordinal is always in 0...2")
        }
    }
}
#endif
