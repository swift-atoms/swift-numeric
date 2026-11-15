extension Numeric.Math {
    @usableFromInline
    enum Trigonometric {}
}

extension Numeric.Math.Trigonometric {
    @usableFromInline
    static func sin(_ x: Double) -> Double {
        if let value = quick(x, cosine: false) { return value }
        return exact(x, cosine: false)
    }

    @usableFromInline
    static func cos(_ x: Double) -> Double {
        if let value = quick(x, cosine: true) { return value }
        return exact(x, cosine: true)
    }

    static func exact(_ x: Double, cosine wanted: Bool) -> Double {
        if !x.isFinite { return .nan }
        if x == 0 { return wanted ? 1 : x }
        let reduced = reduce(x)
        let (sine, cosine) = both(reduced.angle)
        let turn = (reduced.quadrant + (wanted ? 1 : 0)) & 3
        let value: Numeric.Math.Pair
        switch turn {
        case 0: value = sine
        case 1: value = cosine
        case 2: value = -sine
        default: value = -cosine
        }
        return value.high + value.low
    }

    static func quick(_ x: Double, cosine wanted: Bool) -> Double? {
        guard x.magnitude < 1.5e6, x.magnitude > 0x1p-26 else { return nil }
        let k = (x * (2 / Double.pi)).rounded(.toNearestOrEven)
        var r = Numeric.Math.Pair(x - k * quarter[0])
        r = r + Numeric.Math.Pair.product(-k, quarter[1])
        r = r + Numeric.Math.Pair.product(-k, quarter[2])
        r = r + Numeric.Math.Pair.product(-k, quarter[3])
        r = r + -k * quarter[4]
        let y = r.high
        let index = Int((y.magnitude * 64).rounded(.toNearestOrEven))
        let sign: Double = y < 0 ? -1 : 1
        let z = Numeric.Math.Pair(y.magnitude, sign * r.low) + -Double(index) / 64
        let (h, l) = (z.high, z.low)
        let square = h * h
        let sineTail = h * square * (-1.0 / 6 + square * (1.0 / 120 + square * (-1.0 / 5040)))
        let cosineTail = square * (-0.5 + square * (1.0 / 24 + square * (-1.0 / 720 + square / 40320)))
        let point = points[index]
        let turn = (Int(k) & 3) + (wanted ? 1 : 0)
        let high: Double
        let low: Double
        let negative: Bool
        if turn & 1 == 0 {
            let product = Numeric.Math.Pair.product(point.cosine.high, h)
            let joined = Numeric.Math.Pair.sum(point.sine.high, product.high)
            high = joined.high
            low = joined.low + (product.low + (point.sine.high * cosineTail + (point.cosine.high * (l + sineTail) + (point.sine.low + point.cosine.low * h - point.sine.high * h * l))))
            negative = (turn & 2 == 2) != (sign < 0)
        } else {
            let product = Numeric.Math.Pair.product(-point.sine.high, h)
            let joined = Numeric.Math.Pair.sum(point.cosine.high, product.high)
            high = joined.high
            low = joined.low + (product.low + (point.cosine.high * (cosineTail - h * l) + (-point.sine.high * (l + sineTail) + (point.cosine.low - point.sine.low * h))))
            negative = turn & 2 == 2
        }
        guard let value = Numeric.Math.Pair.settled(high, low, within: high.magnitude * 0x1p-62) else { return nil }
        return negative ? -value : value
    }

    static func reduce(_ x: Double) -> Reduced {
        guard x.magnitude >= 1.5e6 else {
            let k = (x * (2 / Double.pi)).rounded(.toNearestOrEven)
            var r = Numeric.Math.Pair(x - k * quarter[0])
            for part in quarter[1...3] {
                r = r + Numeric.Math.Pair.product(-k, part)
            }
            r = r + -k * quarter[4]
            return Reduced(quadrant: Int(k) & 3, angle: r)
        }
        let significand = UInt64(x.significandBitPattern) | (1 << 52)
        let exponent = Int(x.exponent) - 52
        let count = (exponent + 256) / 64 + 1
        var product = [UInt64](repeating: 0, count: count + 1)
        for (place, word) in twoOverPi.prefix(count).reversed().enumerated() {
            let (high, low) = significand.multipliedFullWidth(by: word)
            let (sum, carried) = product[place].addingReportingOverflow(low)
            product[place] = sum
            var carry = high &+ (carried ? 1 : 0)
            var next = place + 1
            while carry != 0 {
                let (added, over) = product[next].addingReportingOverflow(carry)
                product[next] = added
                carry = over ? 1 : 0
                next += 1
            }
        }
        let shift = 64 * count - exponent
        func bit(_ index: Int) -> UInt64 {
            guard index >= 0, index / 64 < product.count else { return 0 }
            return (product[index / 64] >> UInt64(index % 64)) & 1
        }
        var quadrant = Int(bit(shift) | (bit(shift + 1) << 1))
        var fraction = Swift.Array(product.prefix(shift / 64 + 1))
        if shift % 64 != 0 {
            fraction[shift / 64] &= (1 << UInt64(shift % 64)) - 1
        } else {
            fraction.removeLast()
        }
        var negative = false
        if bit(shift - 1) == 1 {
            quadrant = (quadrant + 1) & 3
            negative = true
            var borrow: UInt64 = 1
            for place in fraction.indices {
                let inverted = ~fraction[place]
                let (sum, over) = inverted.addingReportingOverflow(borrow)
                fraction[place] = sum
                borrow = over ? 1 : 0
            }
            if shift % 64 != 0 {
                fraction[shift / 64] &= (1 << UInt64(shift % 64)) - 1
            }
        }
        var top = shift - 1
        func set(_ index: Int) -> Bool {
            (fraction[index / 64] >> UInt64(index % 64)) & 1 == 1
        }
        while top >= 0 && !set(top) {
            top -= 1
        }
        guard top >= 0 else {
            return Reduced(quadrant: x < 0 ? (-quadrant) & 3 : quadrant, angle: Numeric.Math.Pair(0))
        }
        var window: UInt128 = 0
        for index in stride(from: top, to: top - 127, by: -1) {
            window = (window << 1) | (index >= 0 && set(index) ? 1 : 0)
        }
        let high = Double(window)
        let rest = Int128(bitPattern: window &- UInt128(high))
        let scale = top + 1 - 127 - shift
        var angle = Numeric.Math.Pair(
            Double(sign: .plus, exponent: scale, significand: high),
            Double(sign: .plus, exponent: scale, significand: Double(rest))
        )
        angle = Numeric.Math.Pair.ordered(angle.high, angle.low) * half
        if negative { angle = -angle }
        if x < 0 {
            return Reduced(quadrant: (-quadrant) & 3, angle: -angle)
        }
        return Reduced(quadrant: quadrant, angle: angle)
    }

    static func both(_ r: Numeric.Math.Pair) -> (sine: Numeric.Math.Pair, cosine: Numeric.Math.Pair) {
        let y = r.high
        let index = Int((y.magnitude * 64).rounded(.toNearestOrEven))
        let sign: Double = y < 0 ? -1 : 1
        let z = Numeric.Math.Pair(y.magnitude, sign * r.low) + -Double(index) / 64
        let h = z.high
        var sineTail = 0.0
        for (n, positive) in [(15, false), (13, true), (11, false), (9, true)] {
            sineTail = (positive ? 1 : -1) / Double(factorial(n)) + h * h * sineTail
        }
        var cosineTail = 0.0
        for (n, positive) in [(16, true), (14, false), (12, true), (10, false)] {
            cosineTail = (positive ? 1 : -1) / Double(factorial(n)) + h * h * cosineTail
        }
        let square = z * z
        var sineSeries = Numeric.Math.Pair(sineTail)
        for (n, positive) in [(7, false), (5, true), (3, false)] {
            sineSeries = (positive ? factorials[n] : -factorials[n]) + square * sineSeries
        }
        let sineOfZ = z + (square * z) * sineSeries
        var cosineSeries = Numeric.Math.Pair(cosineTail)
        for (n, positive) in [(8, true), (6, false), (4, true), (2, false)] {
            cosineSeries = (positive ? factorials[n] : -factorials[n]) + square * cosineSeries
        }
        let cosineOfZ = square * cosineSeries + 1
        let point = points[index]
        let sine = point.sine * cosineOfZ + point.cosine * sineOfZ
        let cosine = point.cosine * cosineOfZ + -(point.sine * sineOfZ)
        return (Numeric.Math.Pair(sign * sine.high, sign * sine.low), cosine)
    }

    static func factorial(_ n: Int) -> UInt64 {
        (1...n).reduce(1) { $0 * UInt64($1) }
    }

    static let quarter: [Double] = [Double(bitPattern: 0x3FF921FB54400000), Double(bitPattern: 0x3DD0B4611A600000), Double(bitPattern: 0x3BA3198A2E000000), Double(bitPattern: 0x397B839A25200000), Double(bitPattern: 0x37127044533E63A0)]

    static let half = Numeric.Math.Pair(bits: 0x3FF921FB54442D18, 0x3C91A62633145C07)

    static let factorials: [Numeric.Math.Pair] = [
            .init(bits: 0x3FF0000000000000, 0x0000000000000000),
            .init(bits: 0x3FF0000000000000, 0x0000000000000000),
            .init(bits: 0x3FE0000000000000, 0x0000000000000000),
            .init(bits: 0x3FC5555555555555, 0x3C65555555555555),
            .init(bits: 0x3FA5555555555555, 0x3C45555555555555),
            .init(bits: 0x3F81111111111111, 0x3C01111111111111),
            .init(bits: 0x3F56C16C16C16C17, 0xBBEF49F49F49F49F),
            .init(bits: 0x3F2A01A01A01A01A, 0x3B6A01A01A01A01A),
            .init(bits: 0x3EFA01A01A01A01A, 0x3B3A01A01A01A01A),
            .init(bits: 0x3EC71DE3A556C734, 0xBB6C154F8DDC6C00),
            .init(bits: 0x3E927E4FB7789F5C, 0x3B3CBBC05B4FA99A),
            .init(bits: 0x3E5AE64567F544E4, 0xBAFC062E06D1F209),
    ]

    static let points: [Numeric.Math.Trigonometric.Point] = [
            .init(sine: .init(bits: 0x0000000000000000, 0x0000000000000000), cosine: .init(bits: 0x3FF0000000000000, 0x0000000000000000)),
            .init(sine: .init(bits: 0x3F8FFFAAAAEEEED5, 0xBC02AB639A9F0776), cosine: .init(bits: 0x3FEFFF000155549F, 0x3C828A28A03A5EF3)),
            .init(sine: .init(bits: 0x3F9FFEAAAEEEE86F, 0xBC3CD406FB224AE2), cosine: .init(bits: 0x3FEFFC00155527D3, 0xBC83B54492D89B5B)),
            .init(sine: .init(bits: 0x3FA7FDC01032FBA9, 0xBC4599BDF46E997A), cosine: .init(bits: 0x3FEFF7006BFDF99F, 0xBC78B3B560648D5F)),
            .init(sine: .init(bits: 0x3FAFFAAAEEED4EDB, 0xBC42D16D32684B69), cosine: .init(bits: 0x3FEFF0015549F4D3, 0x3C8328387B99426F)),
            .init(sine: .init(bits: 0x3FB3FACB12D1755B, 0xBC5921915299468B), cosine: .init(bits: 0x3FEFE7034129EF6F, 0xBC6CBF4337C96F97)),
            .init(sine: .init(bits: 0x3FB7F701032550E4, 0x3C3AFC2D1800501A), cosine: .init(bits: 0x3FEFDC06BF7E6B9B, 0x3C831902B535F8DB)),
            .init(sine: .init(bits: 0x3FBBF1B78568391D, 0x3C5E91841DEA4CC8), cosine: .init(bits: 0x3FEFCF0C800E99B1, 0x3C6EA3D786D186AC)),
            .init(sine: .init(bits: 0x3FBFEAAEEE86EE36, 0xBC4AFCB2BCC6F03B), cosine: .init(bits: 0x3FEFC015527D5BD3, 0x3C8B68F35094EFB8)),
            .init(sine: .init(bits: 0x3FC1F0D3D7AFCEAF, 0xBC66EF95099769A5), cosine: .init(bits: 0x3FEFAF22263C4BD3, 0xBC552ACE133A2769)),
            .init(sine: .init(bits: 0x3FC3EB312C5D66CB, 0x3C647D666B66CB91), cosine: .init(bits: 0x3FEF9C340A7CC428, 0x3C8C5B6B063B7462)),
            .init(sine: .init(bits: 0x3FC5E44FCFA126F3, 0xBC66F443063F89B6), cosine: .init(bits: 0x3FEF874C2E1EECF6, 0xBC8C6514E1332B16)),
            .init(sine: .init(bits: 0x3FC7DC102FBAF2B5, 0x3C45AB50E23C97C3), cosine: .init(bits: 0x3FEF706BDF9ECE1C, 0xBC8698C80C36DCB4)),
            .init(sine: .init(bits: 0x3FC9D252D0CEC312, 0x3C59C43D80B1137D), cosine: .init(bits: 0x3FEF57948CFF6797, 0x3C6E3A0D3E03B1D4)),
            .init(sine: .init(bits: 0x3FCBC6F84EDC6199, 0x3C69C1A56A7B0CAB), cosine: .init(bits: 0x3FEF3CC7C3B3D16E, 0xBC621A3AD28A3494)),
            .init(sine: .init(bits: 0x3FCDB9E15FB5A5D0, 0xBC632E20D6CC6FC2), cosine: .init(bits: 0x3FEF20073086649F, 0x3C7B940416C1984B)),
            .init(sine: .init(bits: 0x3FCFAAEED4F31577, 0xBC615D88508E32B8), cosine: .init(bits: 0x3FEF01549F7DEEA1, 0x3C8D3C1E99E5CAFD)),
            .init(sine: .init(bits: 0x3FD0CD00CEF36436, 0xBC79FB0A0C93E2B4), cosine: .init(bits: 0x3FEEE0B1FBC0F11C, 0xBC4BFD2380BBC3B1)),
            .init(sine: .init(bits: 0x3FD1C37D64C6B876, 0x3C746076FE0DCFF4), cosine: .init(bits: 0x3FEEBE214F76EFA8, 0xBC802F9F12BA543E)),
            .init(sine: .init(bits: 0x3FD2B8DDC43EB49F, 0x3C61553899F2D807), cosine: .init(bits: 0x3FEE99A4C3A7CD83, 0xBC82264B1BC53CE8)),
            .init(sine: .init(bits: 0x3FD3AD129769D3D8, 0x3C003D550487839A), cosine: .init(bits: 0x3FEE733EA0193D40, 0xBC86428B3546CE13)),
            .init(sine: .init(bits: 0x3FD4A00C9B0F3D20, 0x3C7823BA6BB08EAD), cosine: .init(bits: 0x3FEE4AF14B2A449C, 0xBC868CA02E8A6833)),
            .init(sine: .init(bits: 0x3FD591BC9FA2F597, 0x3C67C74BAC3FE0CB), cosine: .init(bits: 0x3FEE20BF49ACD6C1, 0xBC5660AEC7EF636B)),
            .init(sine: .init(bits: 0x3FD682138A38D7F7, 0xBC7D889202444AAD), cosine: .init(bits: 0x3FEDF4AB3EBD875E, 0xBC8E2D8A7E6736C4)),
            .init(sine: .init(bits: 0x3FD7710255764214, 0xBC66EAD7314BB6CE), cosine: .init(bits: 0x3FEDC6B7EB995912, 0x3C54B364776DCD35)),
            .init(sine: .init(bits: 0x3FD85E7A12826949, 0x3C78A40E9B5FACE0), cosine: .init(bits: 0x3FED96E82F71A9DC, 0x3C8FF61BD5D2039D)),
            .init(sine: .init(bits: 0x3FD94A6BE9F546C5, 0xBC769CE13E683F58), cosine: .init(bits: 0x3FED653F073E4040, 0xBC876236434BEC37)),
            .init(sine: .init(bits: 0x3FDA34C91CC50CCA, 0xBC5A310E3B50CECD), cosine: .init(bits: 0x3FED31BF8D8D7C06, 0x3C7E60DD3089CBDD)),
            .init(sine: .init(bits: 0x3FDB1D8305321617, 0xBC7AE242CB99F519), cosine: .init(bits: 0x3FECFC6CFA52AD9F, 0x3C88B5B5508F2A0D)),
            .init(sine: .init(bits: 0x3FDC048B17B140A3, 0x3C619FE6757E9FA7), cosine: .init(bits: 0x3FECC54AA2B2972E, 0x3C64EE162BA83A98)),
            .init(sine: .init(bits: 0x3FDCE9D2E3D4A51F, 0xBC62FC8A12DAE298), cosine: .init(bits: 0x3FEC8C5BF8CE1A84, 0x3C7AB3D1A1590123)),
            .init(sine: .init(bits: 0x3FDDCD4C15329C9A, 0x3C70D4C6E171FD9A), cosine: .init(bits: 0x3FEC51A48B8B175E, 0xBC61BBB43B9AA880)),
            .init(sine: .init(bits: 0x3FDEAEE8744B05F0, 0xBC5789B43C9B027D), cosine: .init(bits: 0x3FEC1528065B7D50, 0xBC8892111312E828)),
            .init(sine: .init(bits: 0x3FDF8E99E76ABC97, 0x3C59D950AF2D00A3), cosine: .init(bits: 0x3FEBD6EA310294F5, 0x3C731BBCC88C109D)),
            .init(sine: .init(bits: 0x3FE0362939C69955, 0xBC82D8CD78397B01), cosine: .init(bits: 0x3FEB96EEEF58840E, 0x3C545A3CC78FADE0)),
            .init(sine: .init(bits: 0x3FE0A4021E9E1001, 0xBC86F643A13914F6), cosine: .init(bits: 0x3FEB553A410C104E, 0x3C58FF7947027A15)),
            .init(sine: .init(bits: 0x3FE110D0C4B69C3B, 0x3C8D918998809981), cosine: .init(bits: 0x3FEB11D04162A4C6, 0x3C71DD561EFBC0C2)),
            .init(sine: .init(bits: 0x3FE17C8E5F2EEDB0, 0x3C635E57102E2488), cosine: .init(bits: 0x3FEACCB526F69DE5, 0x3C88FB6A8DD6B6CC)),
            .init(sine: .init(bits: 0x3FE1E7343236574C, 0x3C722A3FA4F41D5A), cosine: .init(bits: 0x3FEA85ED4373E02D, 0x3C69BE06385EC792)),
            .init(sine: .init(bits: 0x3FE250BB93788BBB, 0x3C7EA3D02457BCCE), cosine: .init(bits: 0x3FEA3D7D0352BDCF, 0xBC868DBAECA19669)),
            .init(sine: .init(bits: 0x3FE2B91DEA88421E, 0xBC8FA371DB216AB0), cosine: .init(bits: 0x3FE9F368ED912F85, 0xBC81D200C5791606)),
            .init(sine: .init(bits: 0x3FE32054B148BC4F, 0x3C8F6B42095A135B), cosine: .init(bits: 0x3FE9A7B5A36A6514, 0x3C8722CFCC9FA7A9)),
            .init(sine: .init(bits: 0x3FE386597456282B, 0xBC710FADA93B07A8), cosine: .init(bits: 0x3FE95A67E00CB1FD, 0xBC80BEFDA21F862D)),
            .init(sine: .init(bits: 0x3FE3EB25D36CD53A, 0xBC5BE570E1570FC0), cosine: .init(bits: 0x3FE90B84784DDAF7, 0xBC70FEB10AB93B87)),
            .init(sine: .init(bits: 0x3FE44EB381CF386B, 0xBC83ED6C1E6A5505), cosine: .init(bits: 0x3FE8BB105A5DC900, 0x3C8863E03E9474C1)),
            .init(sine: .init(bits: 0x3FE4B0FC46AAB761, 0x3C20DA05738CC59C), cosine: .init(bits: 0x3FE869108D77A6C6, 0x3C7338FFE2BFE9DD)),
            .init(sine: .init(bits: 0x3FE511F9FD7B351C, 0xBC85C0E861C48831), cosine: .init(bits: 0x3FE8158A31916D5D, 0xBC6DE8B90B8228DE)),
            .init(sine: .init(bits: 0x3FE571A6966D59B3, 0x3C5C843B4D0FB197), cosine: .init(bits: 0x3FE7C0827F09E54F, 0xBC6C73D6D72AEE68)),
            .init(sine: .init(bits: 0x3FE5CFFC16BF8F0D, 0x3C896CB370EB578A), cosine: .init(bits: 0x3FE769FEC655211F, 0xBC6827D5CF8C68C5)),
            .init(sine: .init(bits: 0x3FE62CF49921AC79, 0xBC8EDD9855B6241A), cosine: .init(bits: 0x3FE712046FA77678, 0x3C8425B0A5029C81)),
            .init(sine: .init(bits: 0x3FE6888A4E134B2F, 0xBC86B7D37644D5E6), cosine: .init(bits: 0x3FE6B898FA9EFB5D, 0x3C715AC786CCF4B2)),
            .init(sine: .init(bits: 0x3FE6E2B77C40BDE1, 0xBC70E729857FAD53), cosine: .init(bits: 0x3FE65DC1FDEB8CBA, 0xBC597C1B47337C77)),
    ]

    static let twoOverPi: [UInt64] = [
            0xA2F9836E4E441529,
            0xFC2757D1F534DDC0,
            0xDB6295993C439041,
            0xFE5163ABDEBBC561,
            0xB7246E3A424DD2E0,
            0x06492EEA09D1921C,
            0xFE1DEB1CB129A73E,
            0xE88235F52EBB4484,
            0xE99C7026B45F7E41,
            0x3991D639835339F4,
            0x9C845F8BBDF9283B,
            0x1FF897FFDE05980F,
            0xEF2F118B5A0A6D1F,
            0x6D367ECF27CB09B7,
            0x4F463F669E5FEA2D,
            0x7527BAC7EBE5F17B,
            0x3D0739F78A5292EA,
            0x6BFB5FB11F8D5D08,
            0x56033046FC7B6BAB,
            0xF0CFBC209AF4361D,
    ]
}
