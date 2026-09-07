#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
extension Swift.Float16: Numeric.Transcendental {
    @inlinable public static func sin(_ x: Float16) -> Float16 { Numeric.Math.sin(x) }
    @inlinable public static func cos(_ x: Float16) -> Float16 { Numeric.Math.cos(x) }
    @inlinable public static func tan(_ x: Float16) -> Float16 { Numeric.Math.tan(x) }
    @inlinable public static func asin(_ x: Float16) -> Float16 { Numeric.Math.asin(x) }
    @inlinable public static func acos(_ x: Float16) -> Float16 { Numeric.Math.acos(x) }
    @inlinable public static func atan(_ x: Float16) -> Float16 { Numeric.Math.atan(x) }
    @inlinable public static func atan2(_ y: Float16, _ x: Float16) -> Float16 { Numeric.Math.atan2(y, x) }
    @inlinable public static func sinh(_ x: Float16) -> Float16 { Numeric.Math.sinh(x) }
    @inlinable public static func cosh(_ x: Float16) -> Float16 { Numeric.Math.cosh(x) }
    @inlinable public static func tanh(_ x: Float16) -> Float16 { Numeric.Math.tanh(x) }
    @inlinable public static func asinh(_ x: Float16) -> Float16 { Numeric.Math.asinh(x) }
    @inlinable public static func acosh(_ x: Float16) -> Float16 { Numeric.Math.acosh(x) }
    @inlinable public static func atanh(_ x: Float16) -> Float16 { Numeric.Math.atanh(x) }
    @inlinable public static func exp(_ x: Float16) -> Float16 { Numeric.Math.exp(x) }
    @inlinable public static func expm1(_ x: Float16) -> Float16 { Numeric.Math.expm1(x) }
    @inlinable public static func exp2(_ x: Float16) -> Float16 { Numeric.Math.exp2(x) }
    @inlinable public static func log(_ x: Float16) -> Float16 { Numeric.Math.log(x) }
    @inlinable public static func log1p(_ x: Float16) -> Float16 { Numeric.Math.log1p(x) }
    @inlinable public static func log2(_ x: Float16) -> Float16 { Numeric.Math.log2(x) }
    @inlinable public static func log10(_ x: Float16) -> Float16 { Numeric.Math.log10(x) }


        @inlinable public static func _sin(_ x: Float16) -> Float16 { Numeric.Math.sin(x) }

        @inlinable public static func _cos(_ x: Float16) -> Float16 { Numeric.Math.cos(x) }

        @inlinable public static func _tan(_ x: Float16) -> Float16 { Numeric.Math.tan(x) }

        @inlinable public static func _asin(_ x: Float16) -> Float16 { Numeric.Math.asin(x) }

        @inlinable public static func _acos(_ x: Float16) -> Float16 { Numeric.Math.acos(x) }

        @inlinable public static func _atan(_ x: Float16) -> Float16 { Numeric.Math.atan(x) }

        @inlinable public static func _atan2(_ y: Float16, _ x: Float16) -> Float16 {
            Numeric.Math.atan2(y, x)
        }

        @inlinable public static func _sinh(_ x: Float16) -> Float16 { Numeric.Math.sinh(x) }

        @inlinable public static func _cosh(_ x: Float16) -> Float16 { Numeric.Math.cosh(x) }

        @inlinable public static func _tanh(_ x: Float16) -> Float16 { Numeric.Math.tanh(x) }

        @inlinable public static func _asinh(_ x: Float16) -> Float16 { Numeric.Math.asinh(x) }

        @inlinable public static func _acosh(_ x: Float16) -> Float16 { Numeric.Math.acosh(x) }

        @inlinable public static func _atanh(_ x: Float16) -> Float16 { Numeric.Math.atanh(x) }

        @inlinable public static func _exp(_ x: Float16) -> Float16 { Numeric.Math.exp(x) }

        @inlinable public static func _expm1(_ x: Float16) -> Float16 { Numeric.Math.expm1(x) }

        @inlinable public static func _exp2(_ x: Float16) -> Float16 { Numeric.Math.exp2(x) }

        @inlinable public static func _log(_ x: Float16) -> Float16 { Numeric.Math.log(x) }

        @inlinable public static func _log1p(_ x: Float16) -> Float16 { Numeric.Math.log1p(x) }

        @inlinable public static func _log2(_ x: Float16) -> Float16 { Numeric.Math.log2(x) }

        @inlinable public static func _log10(_ x: Float16) -> Float16 { Numeric.Math.log10(x) }

        @inlinable public static func _pow(_ x: Float16, _ y: Float16) -> Float16 {
            Numeric.Math.pow(x, y)
        }

        @inlinable public static func _sqrt(_ x: Float16) -> Float16 { Numeric.Math.sqrt(x) }

        @inlinable public static func _cbrt(_ x: Float16) -> Float16 { Numeric.Math.cbrt(x) }

        @inlinable public static func _hypot(_ x: Float16, _ y: Float16) -> Float16 {
            Numeric.Math.hypot(x, y)
        }
    }
#endif


#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
extension Swift.Float16 {

        @inlinable
        public static var math: Numeric.Math.Accessor<Float16> { .init() }
    }
#endif
