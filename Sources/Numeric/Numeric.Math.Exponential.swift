extension Numeric.Math {
    @usableFromInline
    enum Exponential {}
}

extension Numeric.Math.Exponential {
    @usableFromInline
    static func exp(_ x: Double) -> Double {
        guard x.magnitude < 700, x != 0 else { return exact(x) }
        let k = (x * inverse).rounded(.toNearestOrEven)
        let index = Int(k)
        var r = Numeric.Math.Pair(x - k * step[0])
        r = r + Numeric.Math.Pair.product(-k, step[1])
        r = r + -k * step[2]
        let h = r.high
        let q = h * h * (0.5 + h * (1.0 / 6 + h * (1.0 / 24 + h * (1.0 / 120 + h / 720))))
        let power = powers[index & 127]
        let first = Numeric.Math.Pair.product(power.high, h)
        let joined = Numeric.Math.Pair.ordered(power.high, first.high)
        let low = joined.low + (first.low + (power.high * (r.low + q) + power.low * (1 + h)))
        guard let value = Numeric.Math.Pair.settled(joined.high, low, within: joined.high * 0x1p-63) else { return exact(x) }
        return Double(sign: .plus, exponent: index >> 7, significand: value)
    }

    static func exact(_ x: Double) -> Double {
        if x.isNaN { return x + x }
        if x > 709.79 { return .infinity }
        if x < -745.2 { return 0 }
        if x == 0 { return 1 }
        let k = (x * inverse).rounded(.toNearestOrEven)
        let index = Int(k)
        var r = Numeric.Math.Pair(x - k * step[0])
        r = r + Numeric.Math.Pair.product(-k, step[1])
        r = r + -k * step[2]
        let h = r.high
        var tail = factorials[11].high
        for n in [10, 9, 8, 7, 6] {
            tail = factorials[n].high + h * tail
        }
        var series = factorials[5] + r * Numeric.Math.Pair(tail)
        for n in [4, 3, 2, 1, 0] {
            series = factorials[n] + r * series
        }
        return scaled(powers[index & 127] * series, by: index >> 7)
    }

    static func scaled(_ y: Numeric.Math.Pair, by power: Int) -> Double {
        if power > 1000 {
            return Double(sign: .plus, exponent: power - 1000, significand: y.high + y.low) * Double(sign: .plus, exponent: 1000, significand: 1)
        }
        if Int(y.high.exponent) + power >= -1022 {
            return Double(sign: .plus, exponent: power, significand: y.high + y.low)
        }
        let shift = power + 1074
        let high = Double(sign: .plus, exponent: shift, significand: y.high)
        let low = Double(sign: .plus, exponent: shift, significand: y.low)
        var whole = high.rounded(.toNearestOrEven)
        let rest = (high - whole) + low
        let odd = whole.truncatingRemainder(dividingBy: 2) != 0
        if rest > 0.5 || (rest == 0.5 && odd) {
            whole += 1
        } else if rest < -0.5 || (rest == -0.5 && odd) {
            whole -= 1
        }
        return Double(sign: .plus, exponent: -1074, significand: whole)
    }

    static let inverse = Double(bitPattern: 0x40671547652B82FE)

    static let step: [Double] = [Double(bitPattern: 0x3F762E42FF000000), Double(bitPattern: 0xBD5718432A200000), Double(bitPattern: 0x3B33C7673007E5ED)]

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

    static let powers: [Numeric.Math.Pair] = [
            .init(bits: 0x3FF0000000000000, 0x0000000000000000),
            .init(bits: 0x3FF0163DA9FB3335, 0x3C9B61299AB8CDB7),
            .init(bits: 0x3FF02C9A3E778061, 0xBC719083535B085D),
            .init(bits: 0x3FF04315E86E7F85, 0xBC90A31C1977C96E),
            .init(bits: 0x3FF059B0D3158574, 0x3C8D73E2A475B465),
            .init(bits: 0x3FF0706B29DDF6DE, 0xBC8C91DFE2B13C27),
            .init(bits: 0x3FF0874518759BC8, 0x3C6186BE4BB284FF),
            .init(bits: 0x3FF09E3ECAC6F383, 0x3C91487818316136),
            .init(bits: 0x3FF0B5586CF9890F, 0x3C98A62E4ADC610B),
            .init(bits: 0x3FF0CC922B7247F7, 0x3C901EDC16E24F71),
            .init(bits: 0x3FF0E3EC32D3D1A2, 0x3C403A1727C57B53),
            .init(bits: 0x3FF0FB66AFFED31B, 0xBC6B9BEDC44EBD7B),
            .init(bits: 0x3FF11301D0125B51, 0xBC96C51039449B3A),
            .init(bits: 0x3FF12ABDC06C31CC, 0xBC51B514B36CA5C7),
            .init(bits: 0x3FF1429AAEA92DE0, 0xBC932FBF9AF1369E),
            .init(bits: 0x3FF15A98C8A58E51, 0x3C82406AB9EEAB0A),
            .init(bits: 0x3FF172B83C7D517B, 0xBC819041B9D78A76),
            .init(bits: 0x3FF18AF9388C8DEA, 0xBC911023D1970F6C),
            .init(bits: 0x3FF1A35BEB6FCB75, 0x3C8E5B4C7B4968E4),
            .init(bits: 0x3FF1BBE084045CD4, 0xBC995386352EF607),
            .init(bits: 0x3FF1D4873168B9AA, 0x3C9E016E00A2643C),
            .init(bits: 0x3FF1ED5022FCD91D, 0xBC91DF98027BB78C),
            .init(bits: 0x3FF2063B88628CD6, 0x3C8DC775814A8495),
            .init(bits: 0x3FF21F49917DDC96, 0x3C82A97E9494A5EE),
            .init(bits: 0x3FF2387A6E756238, 0x3C99B07EB6C70573),
            .init(bits: 0x3FF251CE4FB2A63F, 0x3C8AC155BEF4F4A4),
            .init(bits: 0x3FF26B4565E27CDD, 0x3C82BD339940E9D9),
            .init(bits: 0x3FF284DFE1F56381, 0xBC9A4C3A8C3F0D7E),
            .init(bits: 0x3FF29E9DF51FDEE1, 0x3C8612E8AFAD1255),
            .init(bits: 0x3FF2B87FD0DAD990, 0xBC410ADCD6381AA4),
            .init(bits: 0x3FF2D285A6E4030B, 0x3C90024754DB41D5),
            .init(bits: 0x3FF2ECAFA93E2F56, 0x3C71CA0F45D52383),
            .init(bits: 0x3FF306FE0A31B715, 0x3C86F46AD23182E4),
            .init(bits: 0x3FF32170FC4CD831, 0x3C8A9CE78E18047C),
            .init(bits: 0x3FF33C08B26416FF, 0x3C932721843659A6),
            .init(bits: 0x3FF356C55F929FF1, 0xBC8B5CEE5C4E4628),
            .init(bits: 0x3FF371A7373AA9CB, 0xBC963AEABF42EAE2),
            .init(bits: 0x3FF38CAE6D05D866, 0xBC9E958D3C9904BD),
            .init(bits: 0x3FF3A7DB34E59FF7, 0xBC75E436D661F5E3),
            .init(bits: 0x3FF3C32DC313A8E5, 0xBC9EFFF8375D29C3),
            .init(bits: 0x3FF3DEA64C123422, 0x3C8ADA0911F09EBC),
            .init(bits: 0x3FF3FA4504AC801C, 0xBC97D023F956F9F3),
            .init(bits: 0x3FF4160A21F72E2A, 0xBC5EF3691C309278),
            .init(bits: 0x3FF431F5D950A897, 0xBC81C7DDE35F7999),
            .init(bits: 0x3FF44E086061892D, 0x3C489B7A04EF80D0),
            .init(bits: 0x3FF46A41ED1D0057, 0x3C9C944BD1648A76),
            .init(bits: 0x3FF486A2B5C13CD0, 0x3C73C1A3B69062F0),
            .init(bits: 0x3FF4A32AF0D7D3DE, 0x3C99CB62F3D1BE56),
            .init(bits: 0x3FF4BFDAD5362A27, 0x3C7D4397AFEC42E2),
            .init(bits: 0x3FF4DCB299FDDD0D, 0x3C98ECDBBC6A7833),
            .init(bits: 0x3FF4F9B2769D2CA7, 0xBC94B309D25957E3),
            .init(bits: 0x3FF516DAA2CF6642, 0xBC8F768569BD93EF),
            .init(bits: 0x3FF5342B569D4F82, 0xBC807ABE1DB13CAD),
            .init(bits: 0x3FF551A4CA5D920F, 0xBC8D689CEFEDE59B),
            .init(bits: 0x3FF56F4736B527DA, 0x3C99BB2C011D93AD),
            .init(bits: 0x3FF58D12D497C7FD, 0x3C8295E15B9A1DE8),
            .init(bits: 0x3FF5AB07DD485429, 0x3C96324C054647AD),
            .init(bits: 0x3FF5C9268A5946B7, 0x3C3C4B1B816986A2),
            .init(bits: 0x3FF5E76F15AD2148, 0x3C9BA6F93080E65E),
            .init(bits: 0x3FF605E1B976DC09, 0xBC93E2429B56DE47),
            .init(bits: 0x3FF6247EB03A5585, 0xBC9383C17E40B497),
            .init(bits: 0x3FF6434634CCC320, 0xBC8C483C759D8933),
            .init(bits: 0x3FF6623882552225, 0xBC9BB60987591C34),
            .init(bits: 0x3FF68155D44CA973, 0x3C6038AE44F73E65),
            .init(bits: 0x3FF6A09E667F3BCD, 0xBC9BDD3413B26456),
            .init(bits: 0x3FF6C012750BDABF, 0xBC72895667FF0B0D),
            .init(bits: 0x3FF6DFB23C651A2F, 0xBC6BBE3A683C88AB),
            .init(bits: 0x3FF6FF7DF9519484, 0xBC883C0F25860EF6),
            .init(bits: 0x3FF71F75E8EC5F74, 0xBC816E4786887A99),
            .init(bits: 0x3FF73F9A48A58174, 0xBC90A8D96C65D53C),
            .init(bits: 0x3FF75FEB564267C9, 0xBC90245957316DD3),
            .init(bits: 0x3FF780694FDE5D3F, 0x3C9866B80A02162D),
            .init(bits: 0x3FF7A11473EB0187, 0xBC841577EE04992F),
            .init(bits: 0x3FF7C1ED0130C132, 0x3C9F124CD1164DD6),
            .init(bits: 0x3FF7E2F336CF4E62, 0x3C705D02BA15797E),
            .init(bits: 0x3FF80427543E1A12, 0xBC927C86626D972B),
            .init(bits: 0x3FF82589994CCE13, 0xBC9D4C1DD41532D8),
            .init(bits: 0x3FF8471A4623C7AD, 0xBC88D684A341CDFB),
            .init(bits: 0x3FF868D99B4492ED, 0xBC9FC6F89BD4F6BA),
            .init(bits: 0x3FF88AC7D98A6699, 0x3C9994C2F37CB53A),
            .init(bits: 0x3FF8ACE5422AA0DB, 0x3C96E9F156864B27),
            .init(bits: 0x3FF8CF3216B5448C, 0xBC70D55E32E9E3AA),
            .init(bits: 0x3FF8F1AE99157736, 0x3C85CC13A2E3976C),
            .init(bits: 0x3FF9145B0B91FFC6, 0xBC9DD6792E582524),
            .init(bits: 0x3FF93737B0CDC5E5, 0xBC675FC781B57EBC),
            .init(bits: 0x3FF95A44CBC8520F, 0xBC764B7C96A5F039),
            .init(bits: 0x3FF97D829FDE4E50, 0xBC9D185B7C1B85D1),
            .init(bits: 0x3FF9A0F170CA07BA, 0xBC9173BD91CEE632),
            .init(bits: 0x3FF9C49182A3F090, 0x3C7C7C46B071F2BE),
            .init(bits: 0x3FF9E86319E32323, 0x3C7824CA78E64C6E),
            .init(bits: 0x3FFA0C667B5DE565, 0xBC9359495D1CD533),
            .init(bits: 0x3FFA309BEC4A2D33, 0x3C96305C7DDC36AB),
            .init(bits: 0x3FFA5503B23E255D, 0xBC9D2F6EDB8D41E1),
            .init(bits: 0x3FFA799E1330B358, 0x3C9BCB7ECAC563C7),
            .init(bits: 0x3FFA9E6B5579FDBF, 0x3C90FAC90EF7FD31),
            .init(bits: 0x3FFAC36BBFD3F37A, 0xBC8F9234CAE76CD0),
            .init(bits: 0x3FFAE89F995AD3AD, 0x3C97A1CD345DCC81),
            .init(bits: 0x3FFB0E07298DB666, 0xBC9BDEF54C80E425),
            .init(bits: 0x3FFB33A2B84F15FB, 0xBC62805E3084D708),
            .init(bits: 0x3FFB59728DE5593A, 0xBC9C71DFBBBA6DE3),
            .init(bits: 0x3FFB7F76F2FB5E47, 0xBC75584F7E54AC3B),
            .init(bits: 0x3FFBA5B030A1064A, 0xBC9EFCD30E54292E),
            .init(bits: 0x3FFBCC1E904BC1D2, 0x3C823DD07A2D9E84),
            .init(bits: 0x3FFBF2C25BD71E09, 0xBC9EFDCA3F6B9C73),
            .init(bits: 0x3FFC199BDD85529C, 0x3C811065895048DD),
            .init(bits: 0x3FFC40AB5FFFD07A, 0x3C9B4537E083C60A),
            .init(bits: 0x3FFC67F12E57D14B, 0x3C92884DFF483CAD),
            .init(bits: 0x3FFC8F6D9406E7B5, 0x3C71ACBC48805C44),
            .init(bits: 0x3FFCB720DCEF9069, 0x3C7503CBD1E949DB),
            .init(bits: 0x3FFCDF0B555DC3FA, 0xBC8DD83B53829D72),
            .init(bits: 0x3FFD072D4A07897C, 0xBC9CBC3743797A9C),
            .init(bits: 0x3FFD2F87080D89F2, 0xBC9D487B719D8578),
            .init(bits: 0x3FFD5818DCFBA487, 0x3C82ED02D75B3707),
            .init(bits: 0x3FFD80E316C98398, 0xBC911EC18BEDDFE8),
            .init(bits: 0x3FFDA9E603DB3285, 0x3C9C2300696DB532),
            .init(bits: 0x3FFDD321F301B460, 0x3C92DA5778F018C3),
            .init(bits: 0x3FFDFC97337B9B5F, 0xBC91A5CD4F184B5C),
            .init(bits: 0x3FFE264614F5A129, 0xBC97B627817A1496),
            .init(bits: 0x3FFE502EE78B3FF6, 0x3C839E8980A9CC8F),
            .init(bits: 0x3FFE7A51FBC74C83, 0x3C92D522CA0C8DE2),
            .init(bits: 0x3FFEA4AFA2A490DA, 0xBC9E9C23179C2893),
            .init(bits: 0x3FFECF482D8E67F1, 0xBC9C93F3B411AD8C),
            .init(bits: 0x3FFEFA1BEE615A27, 0x3C9DC7F486A4B6B0),
            .init(bits: 0x3FFF252B376BBA97, 0x3C93A1A5BF0D8E43),
            .init(bits: 0x3FFF50765B6E4540, 0x3C99D3E12DD8A18B),
            .init(bits: 0x3FFF7BFDAD9CBE14, 0xBC9DBB12D006350A),
            .init(bits: 0x3FFFA7C1819E90D8, 0x3C874853F3A5931E),
            .init(bits: 0x3FFFD3C22B8F71F1, 0x3C62EB74966579E7),
    ]
}
