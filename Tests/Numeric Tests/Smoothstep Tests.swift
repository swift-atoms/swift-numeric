import Testing

@testable import Numeric

@Suite
struct `Smoothstep Tests` {

    @Test
    func `Smoothstep is zero at zero one at one and one half at one half`() {
        #expect(Double.math.smoothstep(0) == 0)
        #expect(Double.math.smoothstep(1) == 1)
        #expect(Double.math.smoothstep(0.5) == 0.5)
        #expect(Float.math.smoothstep(0.5) == 0.5)
    }

    @Test
    func `Smoothstep is the polynomial s squared times three minus two s`() {
        let share = 0.25
        #expect(Double.math.smoothstep(share) == share * share * (3 - 2 * share))
    }

    @Test
    func `Smoothstep is symmetric about one half`() {
        for share in [0.0, 0.125, 0.25, 0.375, 0.5] {
            #expect(Double.math.smoothstep(share) + Double.math.smoothstep(1 - share) == 1)
        }
    }

    @Test
    func `Smoothstep holds shares outside zero to one at the ends`() {
        #expect(Double.math.smoothstep(-2) == 0)
        #expect(Double.math.smoothstep(3) == 1)
        #expect(Double.math.smoothstep(.infinity) == 1)
        #expect(Double.math.smoothstep(.nan).isNaN)
    }

    @Test
    func `Smoothstep between edges is smoothstep of the share between them`() {
        #expect(Double.math.smoothstep(15, from: 10, to: 20) == 0.5)
        #expect(Double.math.smoothstep(12.5, from: 10, to: 20) == Double.math.smoothstep(0.25))
        #expect(Double.math.smoothstep(5, from: 10, to: 20) == 0)
        #expect(Double.math.smoothstep(25, from: 10, to: 20) == 1)
        #expect(Double.math.smoothstep(12.5, from: 20, to: 10) == Double.math.smoothstep(0.75))
    }

    @Test
    func `Smoothstep between equal edges is a step at the edge`() {
        #expect(Double.math.smoothstep(9, from: 10, to: 10) == 0)
        #expect(Double.math.smoothstep(10, from: 10, to: 10) == 1)
        #expect(Double.math.smoothstep(11, from: 10, to: 10) == 1)
    }
}
