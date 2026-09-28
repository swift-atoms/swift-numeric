#if Finite
public import Cardinal
public import Finite
public import Index
public import Ordinal
public import Tagged

extension Numeric.Sign: Finite.Enumerable {

    @inlinable
    public static var count: Cardinal { Cardinal(UInt(3)) }

    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .positive: Ordinal(UInt(0))
        case .negative: Ordinal(UInt(1))
        case .zero: Ordinal(UInt(2))
        }
    }

    @inlinable
    public init(_unchecked: Void, ordinal: Ordinal) {
        switch ordinal.rawValue {
        case 0: self = .positive
        case 1: self = .negative
        case 2: self = .zero
        default: preconditionFailure("Numeric.Sign ordinal is always in 0...2")
        }
    }
}
#endif
