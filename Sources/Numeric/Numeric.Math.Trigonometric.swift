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
        if k != 0 {
            r += Numeric.Math.Pair.product(-k, quarter[1])
            r += Numeric.Math.Pair.product(-k, quarter[2])
            r += Numeric.Math.Pair.product(-k, quarter[3])
            r += -k * quarter[4]
        }
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
                r += Numeric.Math.Pair.product(-k, part)
            }
            r += -k * quarter[4]
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

    static let quarter: [Double] = [
        Double(bitPattern: 0x3FF9_21FB_5440_0000), Double(bitPattern: 0x3DD0_B461_1A60_0000), Double(bitPattern: 0x3BA3_198A_2E00_0000), Double(bitPattern: 0x397B_839A_2520_0000),
        Double(bitPattern: 0x3712_7044_533E_63A0),
    ]

    static let half = Numeric.Math.Pair(bits: 0x3FF9_21FB_5444_2D18, 0x3C91_A626_3314_5C07)

    static let factorials: [Numeric.Math.Pair] = [
        .init(bits: 0x3FF0_0000_0000_0000, 0x0000_0000_0000_0000),
        .init(bits: 0x3FF0_0000_0000_0000, 0x0000_0000_0000_0000),
        .init(bits: 0x3FE0_0000_0000_0000, 0x0000_0000_0000_0000),
        .init(bits: 0x3FC5_5555_5555_5555, 0x3C65_5555_5555_5555),
        .init(bits: 0x3FA5_5555_5555_5555, 0x3C45_5555_5555_5555),
        .init(bits: 0x3F81_1111_1111_1111, 0x3C01_1111_1111_1111),
        .init(bits: 0x3F56_C16C_16C1_6C17, 0xBBEF_49F4_9F49_F49F),
        .init(bits: 0x3F2A_01A0_1A01_A01A, 0x3B6A_01A0_1A01_A01A),
        .init(bits: 0x3EFA_01A0_1A01_A01A, 0x3B3A_01A0_1A01_A01A),
        .init(bits: 0x3EC7_1DE3_A556_C734, 0xBB6C_154F_8DDC_6C00),
        .init(bits: 0x3E92_7E4F_B778_9F5C, 0x3B3C_BBC0_5B4F_A99A),
        .init(bits: 0x3E5A_E645_67F5_44E4, 0xBAFC_062E_06D1_F209),
    ]

    static let points: [Numeric.Math.Trigonometric.Point] = [
        .init(sine: .init(bits: 0x0000_0000_0000_0000, 0x0000_0000_0000_0000), cosine: .init(bits: 0x3FF0_0000_0000_0000, 0x0000_0000_0000_0000)),
        .init(sine: .init(bits: 0x3F8F_FFAA_AAEE_EED5, 0xBC02_AB63_9A9F_0776), cosine: .init(bits: 0x3FEF_FF00_0155_549F, 0x3C82_8A28_A03A_5EF3)),
        .init(sine: .init(bits: 0x3F9F_FEAA_AEEE_E86F, 0xBC3C_D406_FB22_4AE2), cosine: .init(bits: 0x3FEF_FC00_1555_27D3, 0xBC83_B544_92D8_9B5B)),
        .init(sine: .init(bits: 0x3FA7_FDC0_1032_FBA9, 0xBC45_99BD_F46E_997A), cosine: .init(bits: 0x3FEF_F700_6BFD_F99F, 0xBC78_B3B5_6064_8D5F)),
        .init(sine: .init(bits: 0x3FAF_FAAA_EEED_4EDB, 0xBC42_D16D_3268_4B69), cosine: .init(bits: 0x3FEF_F001_5549_F4D3, 0x3C83_2838_7B99_426F)),
        .init(sine: .init(bits: 0x3FB3_FACB_12D1_755B, 0xBC59_2191_5299_468B), cosine: .init(bits: 0x3FEF_E703_4129_EF6F, 0xBC6C_BF43_37C9_6F97)),
        .init(sine: .init(bits: 0x3FB7_F701_0325_50E4, 0x3C3A_FC2D_1800_501A), cosine: .init(bits: 0x3FEF_DC06_BF7E_6B9B, 0x3C83_1902_B535_F8DB)),
        .init(sine: .init(bits: 0x3FBB_F1B7_8568_391D, 0x3C5E_9184_1DEA_4CC8), cosine: .init(bits: 0x3FEF_CF0C_800E_99B1, 0x3C6E_A3D7_86D1_86AC)),
        .init(sine: .init(bits: 0x3FBF_EAAE_EE86_EE36, 0xBC4A_FCB2_BCC6_F03B), cosine: .init(bits: 0x3FEF_C015_527D_5BD3, 0x3C8B_68F3_5094_EFB8)),
        .init(sine: .init(bits: 0x3FC1_F0D3_D7AF_CEAF, 0xBC66_EF95_0997_69A5), cosine: .init(bits: 0x3FEF_AF22_263C_4BD3, 0xBC55_2ACE_133A_2769)),
        .init(sine: .init(bits: 0x3FC3_EB31_2C5D_66CB, 0x3C64_7D66_6B66_CB91), cosine: .init(bits: 0x3FEF_9C34_0A7C_C428, 0x3C8C_5B6B_063B_7462)),
        .init(sine: .init(bits: 0x3FC5_E44F_CFA1_26F3, 0xBC66_F443_063F_89B6), cosine: .init(bits: 0x3FEF_874C_2E1E_ECF6, 0xBC8C_6514_E133_2B16)),
        .init(sine: .init(bits: 0x3FC7_DC10_2FBA_F2B5, 0x3C45_AB50_E23C_97C3), cosine: .init(bits: 0x3FEF_706B_DF9E_CE1C, 0xBC86_98C8_0C36_DCB4)),
        .init(sine: .init(bits: 0x3FC9_D252_D0CE_C312, 0x3C59_C43D_80B1_137D), cosine: .init(bits: 0x3FEF_5794_8CFF_6797, 0x3C6E_3A0D_3E03_B1D4)),
        .init(sine: .init(bits: 0x3FCB_C6F8_4EDC_6199, 0x3C69_C1A5_6A7B_0CAB), cosine: .init(bits: 0x3FEF_3CC7_C3B3_D16E, 0xBC62_1A3A_D28A_3494)),
        .init(sine: .init(bits: 0x3FCD_B9E1_5FB5_A5D0, 0xBC63_2E20_D6CC_6FC2), cosine: .init(bits: 0x3FEF_2007_3086_649F, 0x3C7B_9404_16C1_984B)),
        .init(sine: .init(bits: 0x3FCF_AAEE_D4F3_1577, 0xBC61_5D88_508E_32B8), cosine: .init(bits: 0x3FEF_0154_9F7D_EEA1, 0x3C8D_3C1E_99E5_CAFD)),
        .init(sine: .init(bits: 0x3FD0_CD00_CEF3_6436, 0xBC79_FB0A_0C93_E2B4), cosine: .init(bits: 0x3FEE_E0B1_FBC0_F11C, 0xBC4B_FD23_80BB_C3B1)),
        .init(sine: .init(bits: 0x3FD1_C37D_64C6_B876, 0x3C74_6076_FE0D_CFF4), cosine: .init(bits: 0x3FEE_BE21_4F76_EFA8, 0xBC80_2F9F_12BA_543E)),
        .init(sine: .init(bits: 0x3FD2_B8DD_C43E_B49F, 0x3C61_5538_99F2_D807), cosine: .init(bits: 0x3FEE_99A4_C3A7_CD83, 0xBC82_264B_1BC5_3CE8)),
        .init(sine: .init(bits: 0x3FD3_AD12_9769_D3D8, 0x3C00_3D55_0487_839A), cosine: .init(bits: 0x3FEE_733E_A019_3D40, 0xBC86_428B_3546_CE13)),
        .init(sine: .init(bits: 0x3FD4_A00C_9B0F_3D20, 0x3C78_23BA_6BB0_8EAD), cosine: .init(bits: 0x3FEE_4AF1_4B2A_449C, 0xBC86_8CA0_2E8A_6833)),
        .init(sine: .init(bits: 0x3FD5_91BC_9FA2_F597, 0x3C67_C74B_AC3F_E0CB), cosine: .init(bits: 0x3FEE_20BF_49AC_D6C1, 0xBC56_60AE_C7EF_636B)),
        .init(sine: .init(bits: 0x3FD6_8213_8A38_D7F7, 0xBC7D_8892_0244_4AAD), cosine: .init(bits: 0x3FED_F4AB_3EBD_875E, 0xBC8E_2D8A_7E67_36C4)),
        .init(sine: .init(bits: 0x3FD7_7102_5576_4214, 0xBC66_EAD7_314B_B6CE), cosine: .init(bits: 0x3FED_C6B7_EB99_5912, 0x3C54_B364_776D_CD35)),
        .init(sine: .init(bits: 0x3FD8_5E7A_1282_6949, 0x3C78_A40E_9B5F_ACE0), cosine: .init(bits: 0x3FED_96E8_2F71_A9DC, 0x3C8F_F61B_D5D2_039D)),
        .init(sine: .init(bits: 0x3FD9_4A6B_E9F5_46C5, 0xBC76_9CE1_3E68_3F58), cosine: .init(bits: 0x3FED_653F_073E_4040, 0xBC87_6236_434B_EC37)),
        .init(sine: .init(bits: 0x3FDA_34C9_1CC5_0CCA, 0xBC5A_310E_3B50_CECD), cosine: .init(bits: 0x3FED_31BF_8D8D_7C06, 0x3C7E_60DD_3089_CBDD)),
        .init(sine: .init(bits: 0x3FDB_1D83_0532_1617, 0xBC7A_E242_CB99_F519), cosine: .init(bits: 0x3FEC_FC6C_FA52_AD9F, 0x3C88_B5B5_508F_2A0D)),
        .init(sine: .init(bits: 0x3FDC_048B_17B1_40A3, 0x3C61_9FE6_757E_9FA7), cosine: .init(bits: 0x3FEC_C54A_A2B2_972E, 0x3C64_EE16_2BA8_3A98)),
        .init(sine: .init(bits: 0x3FDC_E9D2_E3D4_A51F, 0xBC62_FC8A_12DA_E298), cosine: .init(bits: 0x3FEC_8C5B_F8CE_1A84, 0x3C7A_B3D1_A159_0123)),
        .init(sine: .init(bits: 0x3FDD_CD4C_1532_9C9A, 0x3C70_D4C6_E171_FD9A), cosine: .init(bits: 0x3FEC_51A4_8B8B_175E, 0xBC61_BBB4_3B9A_A880)),
        .init(sine: .init(bits: 0x3FDE_AEE8_744B_05F0, 0xBC57_89B4_3C9B_027D), cosine: .init(bits: 0x3FEC_1528_065B_7D50, 0xBC88_9211_1312_E828)),
        .init(sine: .init(bits: 0x3FDF_8E99_E76A_BC97, 0x3C59_D950_AF2D_00A3), cosine: .init(bits: 0x3FEB_D6EA_3102_94F5, 0x3C73_1BBC_C88C_109D)),
        .init(sine: .init(bits: 0x3FE0_3629_39C6_9955, 0xBC82_D8CD_7839_7B01), cosine: .init(bits: 0x3FEB_96EE_EF58_840E, 0x3C54_5A3C_C78F_ADE0)),
        .init(sine: .init(bits: 0x3FE0_A402_1E9E_1001, 0xBC86_F643_A139_14F6), cosine: .init(bits: 0x3FEB_553A_410C_104E, 0x3C58_FF79_4702_7A15)),
        .init(sine: .init(bits: 0x3FE1_10D0_C4B6_9C3B, 0x3C8D_9189_9880_9981), cosine: .init(bits: 0x3FEB_11D0_4162_A4C6, 0x3C71_DD56_1EFB_C0C2)),
        .init(sine: .init(bits: 0x3FE1_7C8E_5F2E_EDB0, 0x3C63_5E57_102E_2488), cosine: .init(bits: 0x3FEA_CCB5_26F6_9DE5, 0x3C88_FB6A_8DD6_B6CC)),
        .init(sine: .init(bits: 0x3FE1_E734_3236_574C, 0x3C72_2A3F_A4F4_1D5A), cosine: .init(bits: 0x3FEA_85ED_4373_E02D, 0x3C69_BE06_385E_C792)),
        .init(sine: .init(bits: 0x3FE2_50BB_9378_8BBB, 0x3C7E_A3D0_2457_BCCE), cosine: .init(bits: 0x3FEA_3D7D_0352_BDCF, 0xBC86_8DBA_ECA1_9669)),
        .init(sine: .init(bits: 0x3FE2_B91D_EA88_421E, 0xBC8F_A371_DB21_6AB0), cosine: .init(bits: 0x3FE9_F368_ED91_2F85, 0xBC81_D200_C579_1606)),
        .init(sine: .init(bits: 0x3FE3_2054_B148_BC4F, 0x3C8F_6B42_095A_135B), cosine: .init(bits: 0x3FE9_A7B5_A36A_6514, 0x3C87_22CF_CC9F_A7A9)),
        .init(sine: .init(bits: 0x3FE3_8659_7456_282B, 0xBC71_0FAD_A93B_07A8), cosine: .init(bits: 0x3FE9_5A67_E00C_B1FD, 0xBC80_BEFD_A21F_862D)),
        .init(sine: .init(bits: 0x3FE3_EB25_D36C_D53A, 0xBC5B_E570_E157_0FC0), cosine: .init(bits: 0x3FE9_0B84_784D_DAF7, 0xBC70_FEB1_0AB9_3B87)),
        .init(sine: .init(bits: 0x3FE4_4EB3_81CF_386B, 0xBC83_ED6C_1E6A_5505), cosine: .init(bits: 0x3FE8_BB10_5A5D_C900, 0x3C88_63E0_3E94_74C1)),
        .init(sine: .init(bits: 0x3FE4_B0FC_46AA_B761, 0x3C20_DA05_738C_C59C), cosine: .init(bits: 0x3FE8_6910_8D77_A6C6, 0x3C73_38FF_E2BF_E9DD)),
        .init(sine: .init(bits: 0x3FE5_11F9_FD7B_351C, 0xBC85_C0E8_61C4_8831), cosine: .init(bits: 0x3FE8_158A_3191_6D5D, 0xBC6D_E8B9_0B82_28DE)),
        .init(sine: .init(bits: 0x3FE5_71A6_966D_59B3, 0x3C5C_843B_4D0F_B197), cosine: .init(bits: 0x3FE7_C082_7F09_E54F, 0xBC6C_73D6_D72A_EE68)),
        .init(sine: .init(bits: 0x3FE5_CFFC_16BF_8F0D, 0x3C89_6CB3_70EB_578A), cosine: .init(bits: 0x3FE7_69FE_C655_211F, 0xBC68_27D5_CF8C_68C5)),
        .init(sine: .init(bits: 0x3FE6_2CF4_9921_AC79, 0xBC8E_DD98_55B6_241A), cosine: .init(bits: 0x3FE7_1204_6FA7_7678, 0x3C84_25B0_A502_9C81)),
        .init(sine: .init(bits: 0x3FE6_888A_4E13_4B2F, 0xBC86_B7D3_7644_D5E6), cosine: .init(bits: 0x3FE6_B898_FA9E_FB5D, 0x3C71_5AC7_86CC_F4B2)),
        .init(sine: .init(bits: 0x3FE6_E2B7_7C40_BDE1, 0xBC70_E729_857F_AD53), cosine: .init(bits: 0x3FE6_5DC1_FDEB_8CBA, 0xBC59_7C1B_4733_7C77)),
    ]

    static let twoOverPi: [UInt64] = [
        0xA2F9_836E_4E44_1529,
        0xFC27_57D1_F534_DDC0,
        0xDB62_9599_3C43_9041,
        0xFE51_63AB_DEBB_C561,
        0xB724_6E3A_424D_D2E0,
        0x0649_2EEA_09D1_921C,
        0xFE1D_EB1C_B129_A73E,
        0xE882_35F5_2EBB_4484,
        0xE99C_7026_B45F_7E41,
        0x3991_D639_8353_39F4,
        0x9C84_5F8B_BDF9_283B,
        0x1FF8_97FF_DE05_980F,
        0xEF2F_118B_5A0A_6D1F,
        0x6D36_7ECF_27CB_09B7,
        0x4F46_3F66_9E5F_EA2D,
        0x7527_BAC7_EBE5_F17B,
        0x3D07_39F7_8A52_92EA,
        0x6BFB_5FB1_1F8D_5D08,
        0x5603_3046_FC7B_6BAB,
        0xF0CF_BC20_9AF4_361D,
    ]
}
