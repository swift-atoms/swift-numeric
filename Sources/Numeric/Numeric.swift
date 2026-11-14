public import Quantizer
public import Rounding

public enum Numeric {

    public typealias `Protocol` = Swift::Numeric
}

extension Numeric {
    public typealias Transcendental = Numeric::Transcendental
}

extension Numeric {

    public typealias Integer = Int
}

extension Numeric { public typealias Quantized = Quantizer::Quantized }

extension Numeric { public typealias Rounding = Rounding::Rounding }

extension Numeric {

    @inlinable
    public static func identical<T: FloatingPoint>(_ a: T, _ b: T) -> Bool {
        a == b ? a.sign == b.sign : a.isNaN && b.isNaN
    }

    @inlinable
    public static func identical<V: SIMD>(_ a: V, _ b: V) -> Bool where V.Scalar: FloatingPoint {
        for lane in a.indices where !identical(a[lane], b[lane]) {
            return false
        }
        return true
    }
}
