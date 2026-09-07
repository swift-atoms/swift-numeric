import Numeric
import Testing

@Suite struct `The compatibility backend supplies the elementary atom contracts` {
    @Test func `Single and double precision witnesses preserve domains and cancellation`() {
        check(Float.self)
        check(Double.self)
    }

    #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
    @Test func `Half precision witnesses preserve domains and cancellation`() {
        check(Float16.self)
    }
    #endif

    private func check<Scalar: BinaryFloatingPoint & Trigonometry.`Protocol` & Exponential.`Protocol`>(
        _: Scalar.Type
    ) {
        let negativeZero = -Scalar.zero
        #expect(Scalar.sin(negativeZero).sign == .minus)
        #expect(Scalar.cos(0) == 1 && Scalar.tan(0) == 0)
        #expect(Scalar.atan2(negativeZero, -1).sign == .minus)
        #expect(Scalar.asin(2).isNaN && Scalar.acos(-2).isNaN)
        #expect(Scalar.atan(.infinity).isFinite)
        #expect(Scalar.sinh(negativeZero).sign == .minus)
        #expect(Scalar.cosh(0) == 1 && Scalar.tanh(.infinity) == 1)
        #expect(Scalar.asinh(-.infinity) == -.infinity)
        #expect(Scalar.acosh(0).isNaN && Scalar.atanh(1) == .infinity)
        #expect(Scalar.exp(-.infinity) == 0 && Scalar.exp2(3) == 8)
        #expect(Scalar.log(0) == -.infinity && Scalar.log(-1).isNaN)
        #expect(Scalar.log2(8) == 3 && Scalar.log10(100) == 2)
        let tiny = Scalar.ulpOfOne / 4
        #expect(1 + tiny == 1)
        #expect(Scalar.expm1(tiny) == tiny && Scalar.log1p(tiny) == tiny)
        #expect(Scalar.expm1(negativeZero).sign == .minus)
        #expect(Scalar.log1p(negativeZero).sign == .minus)
    }
}
