extension Numeric.Math.Accessor where T == Double {

    @inlinable
    public func lgamma(_ x: Double) -> Double { Numeric.Math.lgamma(x) }

    @inlinable
    public func logGamma(_ x: Double) -> Double { Numeric.Math.lgamma(x) }
}

extension Numeric.Math.Accessor where T == Float {

    @inlinable
    public func lgamma(_ x: Float) -> Float { Numeric.Math.lgamma(x) }

    @inlinable
    public func logGamma(_ x: Float) -> Float { Numeric.Math.lgamma(x) }
}

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
    extension Numeric.Math.Accessor where T == Float16 {

        @inlinable
        public func lgamma(_ x: Float16) -> Float16 { Numeric.Math.lgamma(x) }

        @inlinable
        public func logGamma(_ x: Float16) -> Float16 { Numeric.Math.lgamma(x) }
    }
#endif
