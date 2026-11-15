extension Numeric.Math {
    @usableFromInline
    enum Logarithm {}
}

extension Numeric.Math.Logarithm {
    @usableFromInline
    static func log(_ x: Double) -> Double {
        guard x.isNormal, x > 0 else { return exact(x) }
        var m = x.significand
        var power = Int(x.exponent)
        let entry = table[Int((m - 1) * 128)]
        if entry.halved {
            m *= 0.5
            power += 1
        }
        let r: Numeric.Math.Pair
        if entry.inverse == 1 {
            r = Numeric.Math.Pair(m - 1)
        } else {
            let product = Numeric.Math.Pair.product(m, entry.inverse)
            r = Numeric.Math.Pair.sum(product.high - 1, product.low)
        }
        let h = r.high
        let square = Numeric.Math.Pair.product(h, h)
        let half = Numeric.Math.Pair(-0.5 * square.high, -0.5 * square.low)
        let rest = h * square.high * (1.0 / 3 + h * (-0.25 + h * (0.2 + h * (-1.0 / 6 + h * (1.0 / 7 + h * (-0.125 + h / 9))))))
        let exponent = Double(power)
        let first = Numeric.Math.Pair.sum(exponent * two[0], entry.logarithm.high)
        let second = Numeric.Math.Pair.sum(first.high, h)
        let third = Numeric.Math.Pair.sum(second.high, half.high)
        let low = third.low + (second.low + (first.low + (exponent * two[1] + (entry.logarithm.low + (r.low + (half.low + rest - h * r.low))))))
        guard let value = Numeric.Math.Pair.settled(third.high, low, within: third.high.magnitude * 0x1p-62) else { return exact(x) }
        return value
    }

    static func exact(_ x: Double) -> Double {
        if x.isNaN || x < 0 { return .nan }
        if x == 0 { return -.infinity }
        if x == .infinity { return x }
        var (value, power) = x < .leastNormalMagnitude ? (x * Double(sign: .plus, exponent: 54, significand: 1), -54) : (x, 0)
        var m = value.significand
        power += Int(value.exponent)
        let entry = table[Int((m - 1) * 128)]
        if entry.halved {
            m *= 0.5
            power += 1
        }
        let r: Numeric.Math.Pair
        if entry.inverse == 1 {
            r = Numeric.Math.Pair(m - 1)
        } else {
            let product = Numeric.Math.Pair.product(m, entry.inverse)
            r = Numeric.Math.Pair.sum(product.high - 1, product.low)
        }
        let h = r.high
        var tail = 0.0
        for n in stride(from: 20, through: 9, by: -1) {
            tail = (n % 2 == 1 ? 1 / Double(n) : -1 / Double(n)) + h * tail
        }
        var series = Numeric.Math.Pair(tail)
        for n in stride(from: 8, through: 1, by: -1) {
            series = coefficients[n - 1] + r * series
        }
        let exponent = Double(power)
        var total = Numeric.Math.Pair(exponent * two[0])
        total = total + Numeric.Math.Pair.product(exponent, two[1])
        total = total + exponent * two[2]
        total = total + entry.logarithm
        total = total + r * series
        value = total.high + total.low
        return value
    }

    static let two: [Double] = [Double(bitPattern: 0x3FE62E42FEFA3800), Double(bitPattern: 0x3D2EF35793C76800), Double(bitPattern: 0xBA59FF0342542FC3)]

    static let coefficients: [Numeric.Math.Pair] = [
            .init(bits: 0x3FF0000000000000, 0x0000000000000000),
            .init(bits: 0xBFE0000000000000, 0x0000000000000000),
            .init(bits: 0x3FD5555555555555, 0x3C75555555555555),
            .init(bits: 0xBFD0000000000000, 0x0000000000000000),
            .init(bits: 0x3FC999999999999A, 0xBC6999999999999A),
            .init(bits: 0xBFC5555555555555, 0xBC65555555555555),
            .init(bits: 0x3FC2492492492492, 0x3C62492492492492),
            .init(bits: 0xBFC0000000000000, 0x0000000000000000),
    ]

    static let table: [Numeric.Math.Logarithm.Entry] = [
            .init(inverse: Double(bitPattern: 0x3FF0000000000000), logarithm: .init(bits: 0x0000000000000000, 0x0000000000000000), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEFA11CAA01FA12), logarithm: .init(bits: 0x3F87DC475F810A69, 0x3C274944BC161072), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEF6310ACA0DBB5), logarithm: .init(bits: 0x3F93CEA44346A584, 0xBC2865AD48159D00), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEF25F644230AB5), logarithm: .init(bits: 0x3F9B9FC027AF919A, 0xBC390AE69229DC86), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEEE9C7F8458E02), logarithm: .init(bits: 0x3FA1B0D98923D97F, 0xBC474D7444DD6241), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEEAE807ABA01EB), logarithm: .init(bits: 0x3FA58A5BAFC8E4D3, 0xBBFCAB8569C56E40), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEE741AA59750E4), logarithm: .init(bits: 0x3FA95C830EC8E3F2, 0x3C3EB41D00A417E9), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEE3A9179DC1A73), logarithm: .init(bits: 0x3FAD276B8ADB0B56, 0x3C4078F14C95FF53), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEE01E01E01E01E), logarithm: .init(bits: 0x3FB075983598E471, 0x3C5006D2999E22DC), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEDCA01DCA01DCA), logarithm: .init(bits: 0x3FB253F62F0A1417, 0x3C21F6D34E01D981), halved: false),
            .init(inverse: Double(bitPattern: 0x3FED92F2231E7F8A), logarithm: .init(bits: 0x3FB42EDCBEA646EE, 0xBC5511583653349B), halved: false),
            .init(inverse: Double(bitPattern: 0x3FED5CAC807572B2), logarithm: .init(bits: 0x3FB60658A93750C4, 0xBC4F108B1D8436D3), halved: false),
            .init(inverse: Double(bitPattern: 0x3FED272CA3FC5B1A), logarithm: .init(bits: 0x3FB7DA766D7B12D0, 0x3C4A2240644D7DA2), halved: false),
            .init(inverse: Double(bitPattern: 0x3FECF26E5C44BFC6), logarithm: .init(bits: 0x3FB9AB42462033AE, 0xBC4A099E1C184E8E), halved: false),
            .init(inverse: Double(bitPattern: 0x3FECBE6D9601CBE7), logarithm: .init(bits: 0x3FBB78C82BB0EDA0, 0xBC53EF0E61F9B03C), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEC8B265AFB8A42), logarithm: .init(bits: 0x3FBD4313D66CB35D, 0x3C5B90DD951D90FA), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEC5894D10D4986), logarithm: .init(bits: 0x3FBF0A30C01162A4, 0x3C48BE64B8B7759B), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEC26B5392EA01C), logarithm: .init(bits: 0x3FC0671512CA596F, 0xBC52F39B81479B67), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEBF583EE868D8B), logarithm: .init(bits: 0x3FC14785846742AC, 0x3C394409F1D3F83A), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEBC4FD65883E7B), logarithm: .init(bits: 0x3FC2266F190A5ACD, 0xBC6DAB840E7F6177), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEB951E2B18FF23), logarithm: .init(bits: 0x3FC303D718E47FD5, 0xBC6B5AE71F658247), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEB65E2E3BEEE05), logarithm: .init(bits: 0x3FC3DFC2B0ECC62A, 0x3C6BA62B8C13F7F4), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEB37484AD806CE), logarithm: .init(bits: 0x3FC4BA36F39A55E5, 0xBC6F767E433C98AA), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEB094B31D922A4), logarithm: .init(bits: 0x3FC59338D9982085, 0x3C68D16EAABA9419), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEADBE87F94905E), logarithm: .init(bits: 0x3FC66ACD4272AD51, 0xBC49201C9C3D5165), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEAAF1D2F87EBFD), logarithm: .init(bits: 0x3FC740F8F54037A3, 0x3C56D9BF9D57B326), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEA82E65130E159), logarithm: .init(bits: 0x3FC815C0A14357E9, 0x3C5141B7F8C5FA9E), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEA574107688A4A), logarithm: .init(bits: 0x3FC8E928DE886D41, 0x3C42589EB96A6240), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEA2C2A87C51CA0), logarithm: .init(bits: 0x3FC9BB362E7DFB85, 0xBC551439C1FF83E7), halved: false),
            .init(inverse: Double(bitPattern: 0x3FEA01A01A01A01A), logarithm: .init(bits: 0x3FCA8BECFC882F19, 0xBC5A8C37918C39EB), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE9D79F176B682D), logarithm: .init(bits: 0x3FCB5B519E8FB5A6, 0xBC6D5D8023E61E5F), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE9AE24EA5510DA), logarithm: .init(bits: 0x3FCC2968558C18C2, 0x3C36108E3AE024AC), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE9852F0D8EC0FF), logarithm: .init(bits: 0x3FCCF6354E09C5DD, 0x3C6339A07D55B696), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE95CBB0BE377AE), logarithm: .init(bits: 0x3FCDC1BCA0ABEC7B, 0x3C5C698A33316DFB), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE934C67F9B2CE6), logarithm: .init(bits: 0x3FCE8C0252AA5A60, 0xBC3DC074737F9135), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE90D4F120190D5), logarithm: .init(bits: 0x3FCF550A564B7B37, 0xBC613A09202FE73D), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE8E6527AF1373F), logarithm: .init(bits: 0x3FD00E6C45AD501D, 0xBC63B9568FF6FEAD), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE8BFCE8062FF3A), logarithm: .init(bits: 0x3FD071B85FCD590D, 0x3C608B83FCBDEF40), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE899C0F601899C), logarithm: .init(bits: 0x3FD0D46B579AB74B, 0x3C721F640E1E5EC9), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE87427BCC092B9), logarithm: .init(bits: 0x3FD136870293A8B0, 0x3C686CC531DBA494), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE84F00C2780614), logarithm: .init(bits: 0x3FD1980D2DD4236F, 0xBC702C2E4F1B2EB9), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE82A4A0182A4A0), logarithm: .init(bits: 0x3FD1F8FF9E48A2F3, 0xBC693FBF3418960D), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE8060180601806), logarithm: .init(bits: 0x3FD2596010DF763A, 0xBC49EED8AE0EBD3C), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE7E225515A4F1D), logarithm: .init(bits: 0x3FD2B9303AB89D25, 0xBC585AD7F614AB51), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE7BEB3922E017C), logarithm: .init(bits: 0x3FD31871C9544185, 0xBC6EA3598981366F), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE79BAA6BB6398B), logarithm: .init(bits: 0x3FD3772662BFD85C, 0x3C602A7589FBA088), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE77908119AC60D), logarithm: .init(bits: 0x3FD3D54FA5C1F710, 0x3C553668E578D9CD), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE756CAC201756D), logarithm: .init(bits: 0x3FD432EF2A04E813, 0xBC683262E2B59206), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE734F0C541FE8D), logarithm: .init(bits: 0x3FD49006804009D0, 0xBC4BFF0D07C5DF6D), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE713786D9C7C09), logarithm: .init(bits: 0x3FD4EC9732600269, 0xBC71AA87D977DC5E), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE6F26016F26017), logarithm: .init(bits: 0x3FD548A2C3ADD263, 0xBC758CE7BF1846EE), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE6D1A62681C861), logarithm: .init(bits: 0x3FD5A42AB0F4CFE2, 0xBC7C6BCB7DEE9A3D), halved: false),
            .init(inverse: Double(bitPattern: 0x3FE6B1490AA31A3D), logarithm: .init(bits: 0x3FD5FF3070A793D4, 0xBC7063077D7E37B7), halved: false),
            .init(inverse: Double(bitPattern: 0x3FF691473A88D0C0), logarithm: .init(bits: 0xBFD602D08AF091EC, 0xBC7A45DB7CFD9230), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF6719F3601671A), logarithm: .init(bits: 0xBFD5A8CADBBEDFA1, 0xBC364F5081307F22), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF6524F853B4AA3), logarithm: .init(bits: 0xBFD54F431B7BE1A8, 0x3C50B3F6EF6AE452), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF63356B88AC0DE), logarithm: .init(bits: 0xBFD4F637EBBA9810, 0x3C768CB3124B9245), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF614B36831AE94), logarithm: .init(bits: 0xBFD49DA7F3BCC420, 0x3C6D964A168CCACB), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF5F66434292DFC), logarithm: .init(bits: 0xBFD44591E0539F49, 0xBC4A76D6DC2782DA), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF5D867C3ECE2A5), logarithm: .init(bits: 0xBFD3EDF463C1683E, 0x3C6C852FE587DEF8), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF5BABCC647FA91), logarithm: .init(bits: 0xBFD396CE359BBF53, 0x3C45C5663663D163), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF59D61F123CCAA), logarithm: .init(bits: 0xBFD3401E12AECBA0, 0xBC6F95523ADC5C9F), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF5805601580560), logarithm: .init(bits: 0xBFD2E9E2BCE12286, 0x3C6F3ED72E23E134), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF56397BA7C52E2), logarithm: .init(bits: 0xBFD2941AFB186B7C, 0xBC46A4678EBAA300), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF54725E6BB82FE), logarithm: .init(bits: 0xBFD23EC5991EBA49, 0xBC276EBA35BBF0DF), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF52AFF56A8054B), logarithm: .init(bits: 0xBFD1E9E1678899F5, 0xBC564B0DD2687939), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF50F22E111C4C5), logarithm: .init(bits: 0xBFD1956D3B9BC2F9, 0xBC50E75A3542856F), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF4F38F62DD4C9B), logarithm: .init(bits: 0xBFD14167EF367784, 0xBC7EF824DAAF53E9), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF4D843BEDC2C4C), logarithm: .init(bits: 0xBFD0EDD060B78082, 0xBC62D4B610D7D4F5), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF4BD3EDDA68FE1), logarithm: .init(bits: 0xBFD09AA572E6C6D4, 0xBC7F9E17343426A9), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF4A27FAD76014A), logarithm: .init(bits: 0xBFD047E60CDE83B7, 0xBC708869CBF9E344), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF4880522014880), logarithm: .init(bits: 0xBFCFEB2233EA07CB, 0xBC28DE00938B4C30), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF46DCE34596066), logarithm: .init(bits: 0xBFCF474B134DF228, 0x3C39F1DF7B5DAAB7), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF453D9E2C776CA), logarithm: .init(bits: 0xBFCEA4449F04AAF5, 0x3C6F33919AB94074), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF43A2730ABEE4D), logarithm: .init(bits: 0xBFCE020CC6235AB5, 0x3C6F0ADB91423F18), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF420B5265E5951), logarithm: .init(bits: 0xBFCD60A17F903514, 0x3C650DF841A71B7A), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF40782D10E6566), logarithm: .init(bits: 0xBFCCC000C9DB3C52, 0xBC567A2A8500729E), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF3EE8F42A5AF07), logarithm: .init(bits: 0xBFCC2028AB17F9B5, 0xBC6C11AA3853A5F0), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF3D5D991AA75C6), logarithm: .init(bits: 0xBFCB811730B823D4, 0x3C5D7C46328983C6), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF3BD60D9232955), logarithm: .init(bits: 0xBFCAE2CA6F672BD8, 0x3C6A4A356155F779), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF3A524387AC822), logarithm: .init(bits: 0xBFCA454082E6AB03, 0x3C5E0DF823A3CB3D), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF38D22D366088E), logarithm: .init(bits: 0xBFC9A8778DEBAA3A, 0xBC528FBFB0E3F0FC), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF3755BD1C945EE), logarithm: .init(bits: 0xBFC90C6DB9FCBCDB, 0x3C5357718D7CA4CF), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF35DCE5F9F2AF8), logarithm: .init(bits: 0xBFC871213750E994, 0x3C6A97A0CA115D60), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF34679ACE01346), logarithm: .init(bits: 0xBFC7D6903CAF5ACD, 0x3C60B17C301D6E14), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF32F5CED6A1DFA), logarithm: .init(bits: 0xBFC73CB9074FD14D, 0x3C6721A000B4CF01), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF3187758E9EBB6), logarithm: .init(bits: 0xBFC6A399DABBD383, 0xBC676332BD4B341F), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF301C82AC40260), logarithm: .init(bits: 0xBFC60B3100B09474, 0xBC6526CEE0FD7F4A), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF2EB4EA1FED14B), logarithm: .init(bits: 0xBFC5737CC9018CDD, 0x3C600B28EF013C72), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF2D50A012D50A0), logarithm: .init(bits: 0xBFC4DC7B897BC1C7, 0xBC4B60AE1FF0E82E), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF2BEF98E5A3711), logarithm: .init(bits: 0xBFC4462B9DC9B3DC, 0x3C485388D830C709), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF2A91C92F3C105), logarithm: .init(bits: 0xBFC3B08B6757F2A7, 0xBC65E1AD9BE0A4CD), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF293725BB804A5), logarithm: .init(bits: 0xBFC31B994D3A4F86, 0x3C61238B5EFE0665), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF27DFA38A1CE4D), logarithm: .init(bits: 0xBFC28753BC11ABA2, 0x3C67394D9FA33313), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF268B37CD60127), logarithm: .init(bits: 0xBFC1F3B925F25D44, 0xBC608B27BE4E6B15), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF2539D7E9177B2), logarithm: .init(bits: 0xBFC160C8024B27B0, 0x3C4355BFD870AFEB), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF23EB79717605B), logarithm: .init(bits: 0xBFC0CE7ECDCCC28B, 0xBC41B57FEA88DA98), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF22A0122A0122A), logarithm: .init(bits: 0xBFC03CDC0A51EC0D, 0xBC619E2D3F8B7D10), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF21579804855E6), logarithm: .init(bits: 0xBFBF57BC7D9005DB, 0x3C5D361574FB24E2), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF2012012012012), logarithm: .init(bits: 0xBFBE3707EE30487B, 0xBC49399D9AAF3B33), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF1ECF43C7FB84C), logarithm: .init(bits: 0xBFBD179788219362, 0x3C5B12841044A96C), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF1D8F5672E4ABD), logarithm: .init(bits: 0xBFBBF968769FCA18, 0x3C506E4FB7AF9C69), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF1C522FC1CE059), logarithm: .init(bits: 0xBFBADC77EE5AEA8E, 0xBC5D7D8F39BEE658), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF1B17C67F2BAE3), logarithm: .init(bits: 0xBFB9C0C32D4D254D, 0x3C5627A0E199F569), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF19E0119E0119E), logarithm: .init(bits: 0xBFB8A6477A91DC29, 0x3C53D4190A482421), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF18AB083902BDB), logarithm: .init(bits: 0xBFB78D02263D82D7, 0xBC5CBCA5B4FDB87E), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF1778A191BD684), logarithm: .init(bits: 0xBFB674F089365A78, 0xBC4CA64E9980E048), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF1648D50FC3201), logarithm: .init(bits: 0xBFB55E10050E0382, 0xBC59A0629E3973E4), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF151B9A3FDD5C9), logarithm: .init(bits: 0xBFB4485E03DBDFB0, 0xBC53BA349AADBC6D), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF13F0E8D344724), logarithm: .init(bits: 0xBFB333D7F8183F4A, 0x3C4ADAA06E211E9E), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF12C8B89EDC0AC), logarithm: .init(bits: 0xBFB2207B5C7854A1, 0xBC5B3F0431EFB154), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF11A3019A74826), logarithm: .init(bits: 0xBFB10E45B3CAE829, 0xBC59B5ED72E6D974), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF107FBBE011080), logarithm: .init(bits: 0xBFAFFA6911AB9309, 0x3C4CD9F1F95C2EF1), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF0F5EDFAB325A2), logarithm: .init(bits: 0xBFADDA8ADC67EE59, 0x3C431936790BB3B2), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF0E40655826011), logarithm: .init(bits: 0xBFABBCEBFC68F424, 0x3C4CD1862F854848), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF0D24456359E3A), logarithm: .init(bits: 0xBFA9A187B573DE81, 0xBBFB13B26F298A6A), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF0C0A7868B4171), logarithm: .init(bits: 0xBFA788595A3577C8, 0xBC12F7C4C5B3C8BD), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF0AF2F722EECB5), logarithm: .init(bits: 0xBFA5715C4C03CEE1, 0xBC45101DC4EBF91F), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF09DDBA6AF8360), logarithm: .init(bits: 0xBFA35C8BFAA13069, 0x3C050830A65543A8), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF08CABB37565E2), logarithm: .init(bits: 0xBFA149E3E4005A8D, 0x3C3A9A4168FCEBEB), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF07B9F29B8EAE2), logarithm: .init(bits: 0xBF9E72BF2813CE6A, 0x3C38A4BBA6A354FA), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF06AB59C7912FB), logarithm: .init(bits: 0xBF9A55F548C5C427, 0xBC2F60D2FC36A0D9), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF059EEA0727586), logarithm: .init(bits: 0xBF963D6178690BBE, 0x3C318ED4D357C9DC), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF04949CC1664C5), logarithm: .init(bits: 0xBF9228FB1FEA2E0A, 0xBC23284991FE3D5C), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF038C6B78247FC), logarithm: .init(bits: 0xBF8C317384C75F0D, 0xBC2806208C04C21F), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF02864FC7729E9), logarithm: .init(bits: 0xBF841929F968330C, 0xBC23AAE809B43DD0), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF0182436517A37), logarithm: .init(bits: 0xBF78121214586B02, 0x3C1C7D68C0D910F2), halved: true),
            .init(inverse: Double(bitPattern: 0x3FF0000000000000), logarithm: .init(bits: 0x0000000000000000, 0x0000000000000000), halved: true),
    ]
}
