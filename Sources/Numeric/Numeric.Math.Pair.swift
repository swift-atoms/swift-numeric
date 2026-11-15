extension Numeric.Math {
    @usableFromInline
    struct Pair: Sendable {
        var high: Double
        var low: Double

        init(_ high: Double, _ low: Double = 0) {
            self.high = high
            self.low = low
        }

        init(bits high: UInt64, _ low: UInt64) {
            self.init(Double(bitPattern: high), Double(bitPattern: low))
        }
    }
}

extension Numeric.Math.Pair {
    static func sum(_ a: Double, _ b: Double) -> Self {
        let (head, tail) = Numeric.Augmented.sum(a, b)
        return Self(head, tail)
    }

    static func ordered(_ large: Double, _ small: Double) -> Self {
        let (head, tail) = Numeric.Augmented.sum(large: large, small: small)
        return Self(head, tail)
    }

    static func product(_ a: Double, _ b: Double) -> Self {
        let (head, tail) = Numeric.Augmented.product(a, b)
        return Self(head, tail)
    }

    static func + (a: Self, b: Self) -> Self {
        let first = sum(a.high, b.high)
        let second = sum(a.low, b.low)
        let joined = ordered(first.high, first.low + second.high)
        return ordered(joined.high, joined.low + second.low)
    }

    static func + (a: Self, b: Double) -> Self {
        let first = sum(a.high, b)
        return ordered(first.high, first.low + a.low)
    }

    static func * (a: Self, b: Self) -> Self {
        let first = product(a.high, b.high)
        return ordered(first.high, first.low + (a.high * b.low + a.low * b.high))
    }

    static func settled(_ high: Double, _ low: Double, within error: Double) -> Double? {
        let up = high + (low + error)
        let down = high + (low - error)
        return up == down ? up : nil
    }

    static func += (a: inout Self, b: Self) {
        a = a + b
    }

    static func += (a: inout Self, b: Double) {
        a = a + b
    }

    static prefix func - (a: Self) -> Self {
        Self(-a.high, -a.low)
    }
}
