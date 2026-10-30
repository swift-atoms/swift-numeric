import Testing
import Tolerance

@testable import Numeric

@Suite
struct `Elementary Tests` {

    @Test
    func `Exp`() throws {
        let result = Double.math.exp(1.0)

        #expect(try Tolerance(absolute: 1e-10).contains(result, 2.718281828459045))
    }

    @Test
    func `Log`() throws {
        let e = Double.math.exp(1.0)
        let result = Double.math.log(e)
        #expect(try Tolerance(absolute: 1e-10).contains(result, 1.0))
    }

    @Test
    func `sin And Cos`() throws {
        let angle = Double.pi / 4
        let s = Double.math.sin(angle)
        let c = Double.math.cos(angle)

        let expected = Double.math.sqrt(2.0) / 2
        #expect(try Tolerance(absolute: 1e-10).contains(s, expected))
        #expect(try Tolerance(absolute: 1e-10).contains(c, expected))

        #expect(try Tolerance(absolute: 1e-10).contains((s * s + c * c), 1.0))
    }

    @Test
    func `Atan2`() throws {

        let result = Double.math.atan2(1.0, 1.0)
        #expect(try Tolerance(absolute: 1e-10).contains(result, Double.pi / 4))

        let zero = Double.math.atan2(0.0, 1.0)
        #expect(try Tolerance(absolute: 1e-15).contains(zero, 0.0))
    }

    @Test
    func `Hyperbolic`() throws {
        let x = 1.0
        let s = Double.math.sinh(x)
        let c = Double.math.cosh(x)

        #expect(try Tolerance(absolute: 1e-10).contains((c * c - s * s), 1.0))
    }

    @Test
    func `Pow`() throws {
        let result = Double.math.pow(2.0, 3.0)
        #expect(try Tolerance(absolute: 1e-10).contains(result, 8.0))
    }

    @Test
    func `Sqrt`() throws {
        let result = Double.math.sqrt(4.0)
        #expect(try Tolerance(absolute: 1e-15).contains(result, 2.0))
    }

    @Test
    func `Hypot`() throws {

        let result = Double.math.hypot(3.0, 4.0)
        #expect(try Tolerance(absolute: 1e-10).contains(result, 5.0))
    }

    @Test
    func `root Square`() throws {

        let result = Double.math.root(4.0, 2)
        #expect(try Tolerance(absolute: 1e-10).contains(result, 2.0))

        let result2 = Double.math.root(9.0, 2)
        #expect(try Tolerance(absolute: 1e-10).contains(result2, 3.0))
    }

    @Test
    func `root Cube`() throws {

        let result = Double.math.root(8.0, 3)
        #expect(try Tolerance(absolute: 1e-10).contains(result, 2.0))

        let result2 = Double.math.root(27.0, 3)
        #expect(try Tolerance(absolute: 1e-10).contains(result2, 3.0))

        let negResult = Double.math.root(-8.0, 3)
        #expect(try Tolerance(absolute: 1e-10).contains(negResult, -2.0))
    }

    @Test
    func `root Fourth`() throws {

        let result = Double.math.root(16.0, 4)
        #expect(try Tolerance(absolute: 1e-10).contains(result, 2.0))

        let result2 = Double.math.root(81.0, 4)
        #expect(try Tolerance(absolute: 1e-10).contains(result2, 3.0))
    }

    @Test
    func `root Negative Even`() {

        let result = Double.math.root(-4.0, 2)
        #expect(result.isNaN)

        let result2 = Double.math.root(-16.0, 4)
        #expect(result2.isNaN)
    }

    @Test
    func `root Negative Odd`() throws {

        let result = Double.math.root(-27.0, 3)
        #expect(try Tolerance(absolute: 1e-10).contains(result, -3.0))

        let result2 = Double.math.root(-32.0, 5)
        #expect(try Tolerance(absolute: 1e-10).contains(result2, -2.0))
    }

    @Test
    func `root Float`() throws {

        let result: Float = Float.math.root(8.0, 3)
        #expect(try Tolerance(absolute: 1e-5).contains(result, 2.0))

        let negResult: Float = Float.math.root(-8.0, 3)
        #expect(try Tolerance(absolute: 1e-5).contains(negResult, -2.0))
    }

    #if canImport(Darwin) || canImport(Glibc) || canImport(Musl)
        @Test
        func `log Gamma Positive`() throws {

            let result = Double.math.logGamma(1.0)
            #expect(try Tolerance(absolute: 1e-10).contains(result, 0.0))

            let result2 = Double.math.logGamma(2.0)
            #expect(try Tolerance(absolute: 1e-10).contains(result2, 0.0))

            let result3 = Double.math.logGamma(3.0)
            #expect(try Tolerance(absolute: 1e-10).contains(result3, Double.math.log(2.0)))

            let result4 = Double.math.logGamma(4.0)
            #expect(try Tolerance(absolute: 1e-10).contains(result4, Double.math.log(6.0)))
        }

        @Test
        func `log Gamma Float`() throws {

            let result: Float = Float.math.logGamma(3.0)
            #expect(try Tolerance(absolute: 1e-5).contains(result, Float.math.log(2.0)))
        }

        @Test
        func `sign Gamma Positive`() {

            #expect(Double.math.signGamma(1.0) == .plus)
            #expect(Double.math.signGamma(2.5) == .plus)
            #expect(Double.math.signGamma(0.5) == .plus)
            #expect(Double.math.signGamma(100.0) == .plus)
        }

        @Test
        func `sign Gamma Negative Integers`() {

            #expect(Double.math.signGamma(-1.0) == .plus)
            #expect(Double.math.signGamma(-2.0) == .plus)
            #expect(Double.math.signGamma(-3.0) == .plus)
        }

        @Test
        func `sign Gamma Negative Non Integers`() {

            #expect(Double.math.signGamma(-0.5) == .minus)

            #expect(Double.math.signGamma(-1.5) == .plus)

            #expect(Double.math.signGamma(-2.5) == .minus)

            #expect(Double.math.signGamma(-3.5) == .plus)
        }

        @Test
        func `log Gamma And Sign Gamma Consistency`() throws {

            let x = 3.5
            let logG = Double.math.logGamma(x)
            let gamma = Double.math.tgamma(x)
            #expect(try Tolerance(absolute: 1e-10).contains(Double.math.exp(logG), gamma.magnitude))

            #expect(Double.math.signGamma(x) == (gamma >= 0 ? .plus : .minus))
        }
    #endif
}
