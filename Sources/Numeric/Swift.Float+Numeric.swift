extension Swift.Float: Numeric.Transcendental {

    @inlinable public static func _sin(_ x: Float) -> Float { Numeric.Math.sin(x) }

    @inlinable public static func _cos(_ x: Float) -> Float { Numeric.Math.cos(x) }

    @inlinable public static func _tan(_ x: Float) -> Float { Numeric.Math.tan(x) }

    @inlinable public static func _asin(_ x: Float) -> Float { Numeric.Math.asin(x) }

    @inlinable public static func _acos(_ x: Float) -> Float { Numeric.Math.acos(x) }

    @inlinable public static func _atan(_ x: Float) -> Float { Numeric.Math.atan(x) }

    @inlinable public static func _atan2(_ y: Float, _ x: Float) -> Float {
        Numeric.Math.atan2(y, x)
    }

    @inlinable public static func _sinh(_ x: Float) -> Float { Numeric.Math.sinh(x) }

    @inlinable public static func _cosh(_ x: Float) -> Float { Numeric.Math.cosh(x) }

    @inlinable public static func _tanh(_ x: Float) -> Float { Numeric.Math.tanh(x) }

    @inlinable public static func _asinh(_ x: Float) -> Float { Numeric.Math.asinh(x) }

    @inlinable public static func _acosh(_ x: Float) -> Float { Numeric.Math.acosh(x) }

    @inlinable public static func _atanh(_ x: Float) -> Float { Numeric.Math.atanh(x) }

    @inlinable public static func _exp(_ x: Float) -> Float { Numeric.Math.exp(x) }

    @inlinable public static func _expm1(_ x: Float) -> Float { Numeric.Math.expm1(x) }

    @inlinable public static func _exp2(_ x: Float) -> Float { Numeric.Math.exp2(x) }

    @inlinable public static func _log(_ x: Float) -> Float { Numeric.Math.log(x) }

    @inlinable public static func _log1p(_ x: Float) -> Float { Numeric.Math.log1p(x) }

    @inlinable public static func _log2(_ x: Float) -> Float { Numeric.Math.log2(x) }

    @inlinable public static func _log10(_ x: Float) -> Float { Numeric.Math.log10(x) }

    @inlinable public static func _pow(_ x: Float, _ y: Float) -> Float { Numeric.Math.pow(x, y) }

    @inlinable public static func _sqrt(_ x: Float) -> Float { Numeric.Math.sqrt(x) }

    @inlinable public static func _cbrt(_ x: Float) -> Float { Numeric.Math.cbrt(x) }

    @inlinable public static func _hypot(_ x: Float, _ y: Float) -> Float {
        Numeric.Math.hypot(x, y)
    }
}

extension Swift.Float {

    @inlinable
    public static var math: Numeric.Math.Accessor<Float> { .init() }
}
