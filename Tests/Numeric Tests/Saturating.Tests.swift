import Testing
import Numeric

@Suite
struct `Saturating arithmetic clamps at storage boundaries` {
    @Suite struct `Unit tests` {}
    @Suite struct `Edge cases` {}
    @Suite struct `Integration tests` {}
    @Suite(.serialized) struct `Performance tests` {}
}

extension `Saturating arithmetic clamps at storage boundaries`.`Unit tests` {
    @Test
    func `saturating add within bounds`() {
        #expect(Int8(100).saturating.add(10) == 110)
    }

    @Test
    func `saturating subtract within bounds`() {
        #expect(Int8(-100).saturating.subtract(10) == -110)
    }

    @Test
    func `saturating multiply within bounds`() {
        #expect(Int8(10).saturating.multiply(by: 5) == 50)
    }

    @Test
    func `saturating negate within bounds`() {
        #expect(Int8(-50).saturating.negate() == 50)
    }
}

extension `Saturating arithmetic clamps at storage boundaries`.`Edge cases` {
    @Test
    func `saturating add clamps at max`() {
        #expect(Int8.max.saturating.add(10) == Int8.max)
    }

    @Test
    func `saturating subtract clamps at min`() {
        #expect(Int8.min.saturating.subtract(10) == Int8.min)
    }

    @Test
    func `saturating multiply clamps at boundaries`() {
        #expect(Int8(100).saturating.multiply(by: 10) == Int8.max)
        #expect(Int8(-100).saturating.multiply(by: 10) == Int8.min)
    }

    @Test
    func `saturating negate of min clamps at max`() {
        #expect(Int8.min.saturating.negate() == Int8.max)
    }
}
