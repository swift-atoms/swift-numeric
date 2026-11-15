extension Numeric.Math.Logarithm {
    struct Entry: Sendable {
        let inverse: Double
        let logarithm: Numeric.Math.Pair
        let halved: Bool
    }
}
