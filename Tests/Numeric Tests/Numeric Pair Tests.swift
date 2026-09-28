import Numeric
import Testing

@Suite("Numeric Pair")
struct NumericPairTests {

    @Test
    func `sign value pairs a sign with a payload`() {
        let value: Numeric.Sign.Value<Int> = .init(.positive, 1)
        #expect(value.first == .positive)
        #expect(value.second == 1)
    }

    @Test
    func `ternary value pairs a ternary digit with a payload`() {
        let value: Numeric.Ternary.Value<String> = .init(.negative, "coefficient")
        #expect(value.first == .negative)
        #expect(value.second == "coefficient")
    }
}
