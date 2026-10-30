import Testing
import Tolerance

@testable import Numeric

@Suite
struct `Real Tests` {

    #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || ((os(macOS) || targetEnvironment(macCatalyst)) && arch(arm64))
        @Test
        func `float16 Basic Operations`() throws {

            let x: Float16 = 2.0
            let y: Float16 = 3.0

            #expect(try Tolerance(absolute: 1e-2).contains(Float16.math.sqrt(4.0), 2.0))

            #expect(try Tolerance(absolute: 1e-1).contains(Float16.math.pow(x, y), 8.0))

            let e = Float16.math.exp(1.0)
            #expect(try Tolerance(absolute: 1e-1).contains(e, 2.718))
            #expect(try Tolerance(absolute: 1e-2).contains(Float16.math.log(e), 1.0))
        }

        @Test
        func `float16 Trigonometry`() throws {

            #expect(try Tolerance(absolute: 1e-2).contains(Float16.math.sin(Float16.pi / 2), 1.0))

            #expect(try Tolerance(absolute: 1e-3).contains(Float16.math.cos(0), 1.0))

            #expect(try Tolerance(absolute: 1e-2).contains(Float16.math.tan(Float16.pi / 4), 1.0))
        }

        @Test
        func `float16 Root`() throws {

            #expect(try Tolerance(absolute: 1e-2).contains(Float16.math.root(8.0, 3), 2.0))

            #expect(try Tolerance(absolute: 1e-2).contains(Float16.math.root(-8.0, 3), -2.0))
        }

        @Test
        func `float16 Hypot`() throws {

            #expect(try Tolerance(absolute: 1e-2).contains(Float16.math.hypot(3.0, 4.0), 5.0))

            #expect(Float16.math.hypot(.infinity, 0).isInfinite)
            #expect(Float16.math.hypot(0, .infinity).isInfinite)
        }
    #endif
}
