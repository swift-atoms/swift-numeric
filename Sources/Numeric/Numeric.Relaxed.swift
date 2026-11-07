extension Numeric {

    public enum Relaxed {}
}

extension Numeric.Relaxed {

    @inlinable
    public static func sum(_ a: Double, _ b: Double) -> Double {
        a + b
    }

    @inlinable
    public static func product(_ a: Double, _ b: Double) -> Double {
        a * b
    }

    @inlinable
    public static func multiplyAdd(_ a: Double, _ b: Double, _ c: Double) -> Double {
        c + a * b
    }
}

extension Numeric.Relaxed {

    @inlinable
    public static func sum(_ a: Float, _ b: Float) -> Float {
        a + b
    }

    @inlinable
    public static func product(_ a: Float, _ b: Float) -> Float {
        a * b
    }

    @inlinable
    public static func multiplyAdd(_ a: Float, _ b: Float, _ c: Float) -> Float {
        c + a * b
    }
}

#if Complex
    public import Complex

    extension Numeric.Relaxed {

        @inlinable
        public static func sum(
            _ a: Complex.Number<Double>,
            _ b: Complex.Number<Double>
        ) -> Complex.Number<Double> {
            Complex.Number(
                Self.sum(a.real.value, b.real.value),
                Self.sum(a.imaginary.value, b.imaginary.value)
            )
        }

        @inlinable
        public static func product(
            _ a: Complex.Number<Double>,
            _ b: Complex.Number<Double>
        ) -> Complex.Number<Double> {

            Complex.Number(
                Self.sum(
                    Self.product(a.real.value, b.real.value),
                    -Self.product(a.imaginary.value, b.imaginary.value)
                ),
                Self.sum(
                    Self.product(a.real.value, b.imaginary.value),
                    Self.product(a.imaginary.value, b.real.value)
                )
            )
        }

        @inlinable
        public static func multiplyAdd(
            _ a: Complex.Number<Double>,
            _ b: Complex.Number<Double>,
            _ c: Complex.Number<Double>
        ) -> Complex.Number<Double> {
            sum(product(a, b), c)
        }

        @inlinable
        public static func product(
            _ z: Complex.Number<Double>,
            _ s: Double
        ) -> Complex.Number<Double> {
            Complex.Number(
                Self.product(z.real.value, s),
                Self.product(z.imaginary.value, s)
            )
        }

        @inlinable
        public static func product(
            _ s: Double,
            _ z: Complex.Number<Double>
        ) -> Complex.Number<Double> {
            product(z, s)
        }
    }

    extension Numeric.Relaxed {

        @inlinable
        public static func sum(
            _ a: Complex.Number<Float>,
            _ b: Complex.Number<Float>
        ) -> Complex.Number<Float> {
            Complex.Number(
                Self.sum(a.real.value, b.real.value),
                Self.sum(a.imaginary.value, b.imaginary.value)
            )
        }

        @inlinable
        public static func product(
            _ a: Complex.Number<Float>,
            _ b: Complex.Number<Float>
        ) -> Complex.Number<Float> {
            Complex.Number(
                Self.sum(
                    Self.product(a.real.value, b.real.value),
                    -Self.product(a.imaginary.value, b.imaginary.value)
                ),
                Self.sum(
                    Self.product(a.real.value, b.imaginary.value),
                    Self.product(a.imaginary.value, b.real.value)
                )
            )
        }

        @inlinable
        public static func multiplyAdd(
            _ a: Complex.Number<Float>,
            _ b: Complex.Number<Float>,
            _ c: Complex.Number<Float>
        ) -> Complex.Number<Float> {
            sum(product(a, b), c)
        }

        @inlinable
        public static func product(
            _ z: Complex.Number<Float>,
            _ s: Float
        ) -> Complex.Number<Float> {
            Complex.Number(
                Self.product(z.real.value, s),
                Self.product(z.imaginary.value, s)
            )
        }

        @inlinable
        public static func product(
            _ s: Float,
            _ z: Complex.Number<Float>
        ) -> Complex.Number<Float> {
            product(z, s)
        }
    }
#endif
