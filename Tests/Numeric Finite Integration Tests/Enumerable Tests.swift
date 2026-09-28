#if Finite
import Cardinal
import Finite
import Index
import Ordinal
import Tagged
import Numeric
import Testing

@Suite
struct `Enumerable Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
}

extension `Enumerable Tests`.Unit {
    @Test
    func `sign count is three`() {
        #expect(Numeric.Sign.count == Cardinal(UInt(3)))
        #expect(Numeric.Sign.allCases.count == 3)
    }

    @Test
    func `sign positive is ordinal zero`() {
        let value = Numeric.Sign.positive
        #expect(value.ordinal == Ordinal(UInt(0)))
        #expect(Numeric.Sign(_unchecked: (), ordinal: value.ordinal).ordinal == value.ordinal)
    }

    @Test
    func `sign negative is ordinal one`() {
        let value = Numeric.Sign.negative
        #expect(value.ordinal == Ordinal(UInt(1)))
        #expect(Numeric.Sign(_unchecked: (), ordinal: value.ordinal).ordinal == value.ordinal)
    }

    @Test
    func `sign zero is ordinal two`() {
        let value = Numeric.Sign.zero
        #expect(value.ordinal == Ordinal(UInt(2)))
        #expect(Numeric.Sign(_unchecked: (), ordinal: value.ordinal).ordinal == value.ordinal)
    }

    @Test
    func `sign rejects an out of range ordinal`() {
        #expect(Numeric.Sign(Ordinal(UInt(3))) == nil)
    }

    @Test
    func `ternary count is three`() {
        #expect(Numeric.Ternary.count == Cardinal(UInt(3)))
        #expect(Numeric.Ternary.allCases.count == 3)
    }

    @Test
    func `ternary negative is ordinal zero`() {
        let value = Numeric.Ternary.negative
        #expect(value.ordinal == Ordinal(UInt(0)))
        #expect(Numeric.Ternary(_unchecked: (), ordinal: value.ordinal).ordinal == value.ordinal)
    }

    @Test
    func `ternary zero is ordinal one`() {
        let value = Numeric.Ternary.zero
        #expect(value.ordinal == Ordinal(UInt(1)))
        #expect(Numeric.Ternary(_unchecked: (), ordinal: value.ordinal).ordinal == value.ordinal)
    }

    @Test
    func `ternary positive is ordinal two`() {
        let value = Numeric.Ternary.positive
        #expect(value.ordinal == Ordinal(UInt(2)))
        #expect(Numeric.Ternary(_unchecked: (), ordinal: value.ordinal).ordinal == value.ordinal)
    }

    @Test
    func `ternary rejects an out of range ordinal`() {
        #expect(Numeric.Ternary(Ordinal(UInt(3))) == nil)
    }
}

#endif
