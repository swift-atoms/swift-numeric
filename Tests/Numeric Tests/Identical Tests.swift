import Testing

@testable import Numeric

@Suite
struct `Identical Tests` {

    static func values<T: BinaryFloatingPoint>(_: T.Type) -> [T] {
        [
            0, -T(0), 1, -1, T.ulpOfOne, T.leastNonzeroMagnitude, -T.leastNonzeroMagnitude,
            T.leastNormalMagnitude, T.greatestFiniteMagnitude, -T.greatestFiniteMagnitude,
            T.infinity, -T.infinity,
        ]
    }

    static func notANumbers<T: BinaryFloatingPoint>(_: T.Type) -> [T] {
        let exponent = T.infinity.exponentBitPattern
        let quiet = T.RawSignificand(1) << (T.significandBitCount - 1)
        return [
            T.nan, -T.nan, T.signalingNaN, -T.signalingNaN,
            T(sign: .plus, exponentBitPattern: exponent, significandBitPattern: quiet | 1),
            T(sign: .minus, exponentBitPattern: exponent, significandBitPattern: quiet | 1),
            T(sign: .plus, exponentBitPattern: exponent, significandBitPattern: 1),
            T(sign: .minus, exponentBitPattern: exponent, significandBitPattern: quiet - 1),
        ]
    }

    static func reflexive<T: BinaryFloatingPoint>(_: T.Type) {
        for value in values(T.self) + notANumbers(T.self) {
            #expect(Numeric.identical(value, value))
        }
    }

    static func notANumbersAreIdentical<T: BinaryFloatingPoint>(_: T.Type) {
        for a in notANumbers(T.self) {
            #expect(a.isNaN)
            for b in notANumbers(T.self) {
                #expect(Numeric.identical(a, b))
            }
        }
    }

    static func zerosDiffer<T: BinaryFloatingPoint>(_: T.Type) {
        #expect(!Numeric.identical(T(0), -T(0)))
        #expect(!Numeric.identical(-T(0), T(0)))
    }

    static func adjacentNumbersDiffer<T: BinaryFloatingPoint>(_: T.Type) {
        for value in values(T.self) where value.isFinite {
            #expect(!Numeric.identical(value, value.nextUp))
            #expect(!Numeric.identical(value.nextDown, value))
        }
    }

    static func notANumberIsNoNumber<T: BinaryFloatingPoint>(_: T.Type) {
        for a in notANumbers(T.self) {
            for b in values(T.self) {
                #expect(!Numeric.identical(a, b))
                #expect(!Numeric.identical(b, a))
            }
        }
    }

    @Test
    func `Identical is reflexive for every value including each not a number`() {
        Self.reflexive(Float.self)
        Self.reflexive(Double.self)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
            Self.reflexive(Float16.self)
        #endif
    }

    @Test
    func `Quiet signalling negative and payload carrying not a numbers are all identical`() {
        Self.notANumbersAreIdentical(Float.self)
        Self.notANumbersAreIdentical(Double.self)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
            Self.notANumbersAreIdentical(Float16.self)
        #endif
    }

    @Test
    func `Positive zero and negative zero are not identical`() {
        Self.zerosDiffer(Float.self)
        Self.zerosDiffer(Double.self)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
            Self.zerosDiffer(Float16.self)
        #endif
    }

    @Test
    func `Adjacent representable numbers are not identical`() {
        Self.adjacentNumbersDiffer(Float.self)
        Self.adjacentNumbersDiffer(Double.self)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
            Self.adjacentNumbersDiffer(Float16.self)
        #endif
    }

    @Test
    func `A not a number is identical to no number`() {
        Self.notANumberIsNoNumber(Float.self)
        Self.notANumberIsNoNumber(Double.self)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
            Self.notANumberIsNoNumber(Float16.self)
        #endif
    }

    @Test
    func `Vectors are identical exactly when every lane is identical`() {
        let base = SIMD4<Float>(1, -0.0, .infinity, .nan)
        #expect(Numeric.identical(base, base))
        #expect(Numeric.identical(base, SIMD4<Float>(1, -0.0, .infinity, -.signalingNaN)))
        #expect(!Numeric.identical(base, SIMD4<Float>(1, 0, .infinity, .nan)))
        #expect(!Numeric.identical(base, SIMD4<Float>(Float(1).nextUp, -0.0, .infinity, .nan)))
        #expect(!Numeric.identical(base, SIMD4<Float>(1, -0.0, .infinity, .infinity)))
        #expect(Numeric.identical(SIMD2<Double>(.nan, -0.0), SIMD2<Double>(-.nan, -0.0)))
        #expect(!Numeric.identical(SIMD2<Double>(.nan, -0.0), SIMD2<Double>(.nan, 0)))
    }
}
