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

    static let two: [Double] = [Double(bitPattern: 0x3FE6_2E42_FEFA_3800), Double(bitPattern: 0x3D2E_F357_93C7_6800), Double(bitPattern: 0xBA59_FF03_4254_2FC3)]

    static let coefficients: [Numeric.Math.Pair] = [
        .init(bits: 0x3FF0_0000_0000_0000, 0x0000_0000_0000_0000),
        .init(bits: 0xBFE0_0000_0000_0000, 0x0000_0000_0000_0000),
        .init(bits: 0x3FD5_5555_5555_5555, 0x3C75_5555_5555_5555),
        .init(bits: 0xBFD0_0000_0000_0000, 0x0000_0000_0000_0000),
        .init(bits: 0x3FC9_9999_9999_999A, 0xBC69_9999_9999_999A),
        .init(bits: 0xBFC5_5555_5555_5555, 0xBC65_5555_5555_5555),
        .init(bits: 0x3FC2_4924_9249_2492, 0x3C62_4924_9249_2492),
        .init(bits: 0xBFC0_0000_0000_0000, 0x0000_0000_0000_0000),
    ]

    static let table: [Numeric.Math.Logarithm.Entry] = [
        .init(inverse: Double(bitPattern: 0x3FF0_0000_0000_0000), logarithm: .init(bits: 0x0000_0000_0000_0000, 0x0000_0000_0000_0000), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEF_A11C_AA01_FA12), logarithm: .init(bits: 0x3F87_DC47_5F81_0A69, 0x3C27_4944_BC16_1072), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEF_6310_ACA0_DBB5), logarithm: .init(bits: 0x3F93_CEA4_4346_A584, 0xBC28_65AD_4815_9D00), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEF_25F6_4423_0AB5), logarithm: .init(bits: 0x3F9B_9FC0_27AF_919A, 0xBC39_0AE6_9229_DC86), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEE_E9C7_F845_8E02), logarithm: .init(bits: 0x3FA1_B0D9_8923_D97F, 0xBC47_4D74_44DD_6241), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEE_AE80_7ABA_01EB), logarithm: .init(bits: 0x3FA5_8A5B_AFC8_E4D3, 0xBBFC_AB85_69C5_6E40), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEE_741A_A597_50E4), logarithm: .init(bits: 0x3FA9_5C83_0EC8_E3F2, 0x3C3E_B41D_00A4_17E9), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEE_3A91_79DC_1A73), logarithm: .init(bits: 0x3FAD_276B_8ADB_0B56, 0x3C40_78F1_4C95_FF53), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEE_01E0_1E01_E01E), logarithm: .init(bits: 0x3FB0_7598_3598_E471, 0x3C50_06D2_999E_22DC), halved: false),
        .init(inverse: Double(bitPattern: 0x3FED_CA01_DCA0_1DCA), logarithm: .init(bits: 0x3FB2_53F6_2F0A_1417, 0x3C21_F6D3_4E01_D981), halved: false),
        .init(inverse: Double(bitPattern: 0x3FED_92F2_231E_7F8A), logarithm: .init(bits: 0x3FB4_2EDC_BEA6_46EE, 0xBC55_1158_3653_349B), halved: false),
        .init(inverse: Double(bitPattern: 0x3FED_5CAC_8075_72B2), logarithm: .init(bits: 0x3FB6_0658_A937_50C4, 0xBC4F_108B_1D84_36D3), halved: false),
        .init(inverse: Double(bitPattern: 0x3FED_272C_A3FC_5B1A), logarithm: .init(bits: 0x3FB7_DA76_6D7B_12D0, 0x3C4A_2240_644D_7DA2), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEC_F26E_5C44_BFC6), logarithm: .init(bits: 0x3FB9_AB42_4620_33AE, 0xBC4A_099E_1C18_4E8E), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEC_BE6D_9601_CBE7), logarithm: .init(bits: 0x3FBB_78C8_2BB0_EDA0, 0xBC53_EF0E_61F9_B03C), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEC_8B26_5AFB_8A42), logarithm: .init(bits: 0x3FBD_4313_D66C_B35D, 0x3C5B_90DD_951D_90FA), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEC_5894_D10D_4986), logarithm: .init(bits: 0x3FBF_0A30_C011_62A4, 0x3C48_BE64_B8B7_759B), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEC_26B5_392E_A01C), logarithm: .init(bits: 0x3FC0_6715_12CA_596F, 0xBC52_F39B_8147_9B67), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEB_F583_EE86_8D8B), logarithm: .init(bits: 0x3FC1_4785_8467_42AC, 0x3C39_4409_F1D3_F83A), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEB_C4FD_6588_3E7B), logarithm: .init(bits: 0x3FC2_266F_190A_5ACD, 0xBC6D_AB84_0E7F_6177), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEB_951E_2B18_FF23), logarithm: .init(bits: 0x3FC3_03D7_18E4_7FD5, 0xBC6B_5AE7_1F65_8247), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEB_65E2_E3BE_EE05), logarithm: .init(bits: 0x3FC3_DFC2_B0EC_C62A, 0x3C6B_A62B_8C13_F7F4), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEB_3748_4AD8_06CE), logarithm: .init(bits: 0x3FC4_BA36_F39A_55E5, 0xBC6F_767E_433C_98AA), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEB_094B_31D9_22A4), logarithm: .init(bits: 0x3FC5_9338_D998_2085, 0x3C68_D16E_AABA_9419), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEA_DBE8_7F94_905E), logarithm: .init(bits: 0x3FC6_6ACD_4272_AD51, 0xBC49_201C_9C3D_5165), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEA_AF1D_2F87_EBFD), logarithm: .init(bits: 0x3FC7_40F8_F540_37A3, 0x3C56_D9BF_9D57_B326), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEA_82E6_5130_E159), logarithm: .init(bits: 0x3FC8_15C0_A143_57E9, 0x3C51_41B7_F8C5_FA9E), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEA_5741_0768_8A4A), logarithm: .init(bits: 0x3FC8_E928_DE88_6D41, 0x3C42_589E_B96A_6240), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEA_2C2A_87C5_1CA0), logarithm: .init(bits: 0x3FC9_BB36_2E7D_FB85, 0xBC55_1439_C1FF_83E7), halved: false),
        .init(inverse: Double(bitPattern: 0x3FEA_01A0_1A01_A01A), logarithm: .init(bits: 0x3FCA_8BEC_FC88_2F19, 0xBC5A_8C37_918C_39EB), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE9_D79F_176B_682D), logarithm: .init(bits: 0x3FCB_5B51_9E8F_B5A6, 0xBC6D_5D80_23E6_1E5F), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE9_AE24_EA55_10DA), logarithm: .init(bits: 0x3FCC_2968_558C_18C2, 0x3C36_108E_3AE0_24AC), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE9_852F_0D8E_C0FF), logarithm: .init(bits: 0x3FCC_F635_4E09_C5DD, 0x3C63_39A0_7D55_B696), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE9_5CBB_0BE3_77AE), logarithm: .init(bits: 0x3FCD_C1BC_A0AB_EC7B, 0x3C5C_698A_3331_6DFB), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE9_34C6_7F9B_2CE6), logarithm: .init(bits: 0x3FCE_8C02_52AA_5A60, 0xBC3D_C074_737F_9135), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE9_0D4F_1201_90D5), logarithm: .init(bits: 0x3FCF_550A_564B_7B37, 0xBC61_3A09_202F_E73D), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE8_E652_7AF1_373F), logarithm: .init(bits: 0x3FD0_0E6C_45AD_501D, 0xBC63_B956_8FF6_FEAD), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE8_BFCE_8062_FF3A), logarithm: .init(bits: 0x3FD0_71B8_5FCD_590D, 0x3C60_8B83_FCBD_EF40), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE8_99C0_F601_899C), logarithm: .init(bits: 0x3FD0_D46B_579A_B74B, 0x3C72_1F64_0E1E_5EC9), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE8_7427_BCC0_92B9), logarithm: .init(bits: 0x3FD1_3687_0293_A8B0, 0x3C68_6CC5_31DB_A494), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE8_4F00_C278_0614), logarithm: .init(bits: 0x3FD1_980D_2DD4_236F, 0xBC70_2C2E_4F1B_2EB9), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE8_2A4A_0182_A4A0), logarithm: .init(bits: 0x3FD1_F8FF_9E48_A2F3, 0xBC69_3FBF_3418_960D), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE8_0601_8060_1806), logarithm: .init(bits: 0x3FD2_5960_10DF_763A, 0xBC49_EED8_AE0E_BD3C), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE7_E225_515A_4F1D), logarithm: .init(bits: 0x3FD2_B930_3AB8_9D25, 0xBC58_5AD7_F614_AB51), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE7_BEB3_922E_017C), logarithm: .init(bits: 0x3FD3_1871_C954_4185, 0xBC6E_A359_8981_366F), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE7_9BAA_6BB6_398B), logarithm: .init(bits: 0x3FD3_7726_62BF_D85C, 0x3C60_2A75_89FB_A088), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE7_7908_119A_C60D), logarithm: .init(bits: 0x3FD3_D54F_A5C1_F710, 0x3C55_3668_E578_D9CD), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE7_56CA_C201_756D), logarithm: .init(bits: 0x3FD4_32EF_2A04_E813, 0xBC68_3262_E2B5_9206), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE7_34F0_C541_FE8D), logarithm: .init(bits: 0x3FD4_9006_8040_09D0, 0xBC4B_FF0D_07C5_DF6D), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE7_1378_6D9C_7C09), logarithm: .init(bits: 0x3FD4_EC97_3260_0269, 0xBC71_AA87_D977_DC5E), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE6_F260_16F2_6017), logarithm: .init(bits: 0x3FD5_48A2_C3AD_D263, 0xBC75_8CE7_BF18_46EE), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE6_D1A6_2681_C861), logarithm: .init(bits: 0x3FD5_A42A_B0F4_CFE2, 0xBC7C_6BCB_7DEE_9A3D), halved: false),
        .init(inverse: Double(bitPattern: 0x3FE6_B149_0AA3_1A3D), logarithm: .init(bits: 0x3FD5_FF30_70A7_93D4, 0xBC70_6307_7D7E_37B7), halved: false),
        .init(inverse: Double(bitPattern: 0x3FF6_9147_3A88_D0C0), logarithm: .init(bits: 0xBFD6_02D0_8AF0_91EC, 0xBC7A_45DB_7CFD_9230), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF6_719F_3601_671A), logarithm: .init(bits: 0xBFD5_A8CA_DBBE_DFA1, 0xBC36_4F50_8130_7F22), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF6_524F_853B_4AA3), logarithm: .init(bits: 0xBFD5_4F43_1B7B_E1A8, 0x3C50_B3F6_EF6A_E452), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF6_3356_B88A_C0DE), logarithm: .init(bits: 0xBFD4_F637_EBBA_9810, 0x3C76_8CB3_124B_9245), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF6_14B3_6831_AE94), logarithm: .init(bits: 0xBFD4_9DA7_F3BC_C420, 0x3C6D_964A_168C_CACB), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_F664_3429_2DFC), logarithm: .init(bits: 0xBFD4_4591_E053_9F49, 0xBC4A_76D6_DC27_82DA), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_D867_C3EC_E2A5), logarithm: .init(bits: 0xBFD3_EDF4_63C1_683E, 0x3C6C_852F_E587_DEF8), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_BABC_C647_FA91), logarithm: .init(bits: 0xBFD3_96CE_359B_BF53, 0x3C45_C566_3663_D163), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_9D61_F123_CCAA), logarithm: .init(bits: 0xBFD3_401E_12AE_CBA0, 0xBC6F_9552_3ADC_5C9F), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_8056_0158_0560), logarithm: .init(bits: 0xBFD2_E9E2_BCE1_2286, 0x3C6F_3ED7_2E23_E134), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_6397_BA7C_52E2), logarithm: .init(bits: 0xBFD2_941A_FB18_6B7C, 0xBC46_A467_8EBA_A300), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_4725_E6BB_82FE), logarithm: .init(bits: 0xBFD2_3EC5_991E_BA49, 0xBC27_6EBA_35BB_F0DF), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_2AFF_56A8_054B), logarithm: .init(bits: 0xBFD1_E9E1_6788_99F5, 0xBC56_4B0D_D268_7939), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF5_0F22_E111_C4C5), logarithm: .init(bits: 0xBFD1_956D_3B9B_C2F9, 0xBC50_E75A_3542_856F), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_F38F_62DD_4C9B), logarithm: .init(bits: 0xBFD1_4167_EF36_7784, 0xBC7E_F824_DAAF_53E9), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_D843_BEDC_2C4C), logarithm: .init(bits: 0xBFD0_EDD0_60B7_8082, 0xBC62_D4B6_10D7_D4F5), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_BD3E_DDA6_8FE1), logarithm: .init(bits: 0xBFD0_9AA5_72E6_C6D4, 0xBC7F_9E17_3434_26A9), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_A27F_AD76_014A), logarithm: .init(bits: 0xBFD0_47E6_0CDE_83B7, 0xBC70_8869_CBF9_E344), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_8805_2201_4880), logarithm: .init(bits: 0xBFCF_EB22_33EA_07CB, 0xBC28_DE00_938B_4C30), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_6DCE_3459_6066), logarithm: .init(bits: 0xBFCF_474B_134D_F228, 0x3C39_F1DF_7B5D_AAB7), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_53D9_E2C7_76CA), logarithm: .init(bits: 0xBFCE_A444_9F04_AAF5, 0x3C6F_3391_9AB9_4074), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_3A27_30AB_EE4D), logarithm: .init(bits: 0xBFCE_020C_C623_5AB5, 0x3C6F_0ADB_9142_3F18), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_20B5_265E_5951), logarithm: .init(bits: 0xBFCD_60A1_7F90_3514, 0x3C65_0DF8_41A7_1B7A), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF4_0782_D10E_6566), logarithm: .init(bits: 0xBFCC_C000_C9DB_3C52, 0xBC56_7A2A_8500_729E), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_EE8F_42A5_AF07), logarithm: .init(bits: 0xBFCC_2028_AB17_F9B5, 0xBC6C_11AA_3853_A5F0), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_D5D9_91AA_75C6), logarithm: .init(bits: 0xBFCB_8117_30B8_23D4, 0x3C5D_7C46_3289_83C6), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_BD60_D923_2955), logarithm: .init(bits: 0xBFCA_E2CA_6F67_2BD8, 0x3C6A_4A35_6155_F779), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_A524_387A_C822), logarithm: .init(bits: 0xBFCA_4540_82E6_AB03, 0x3C5E_0DF8_23A3_CB3D), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_8D22_D366_088E), logarithm: .init(bits: 0xBFC9_A877_8DEB_AA3A, 0xBC52_8FBF_B0E3_F0FC), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_755B_D1C9_45EE), logarithm: .init(bits: 0xBFC9_0C6D_B9FC_BCDB, 0x3C53_5771_8D7C_A4CF), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_5DCE_5F9F_2AF8), logarithm: .init(bits: 0xBFC8_7121_3750_E994, 0x3C6A_97A0_CA11_5D60), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_4679_ACE0_1346), logarithm: .init(bits: 0xBFC7_D690_3CAF_5ACD, 0x3C60_B17C_301D_6E14), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_2F5C_ED6A_1DFA), logarithm: .init(bits: 0xBFC7_3CB9_074F_D14D, 0x3C67_21A0_00B4_CF01), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_1877_58E9_EBB6), logarithm: .init(bits: 0xBFC6_A399_DABB_D383, 0xBC67_6332_BD4B_341F), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF3_01C8_2AC4_0260), logarithm: .init(bits: 0xBFC6_0B31_00B0_9474, 0xBC65_26CE_E0FD_7F4A), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_EB4E_A1FE_D14B), logarithm: .init(bits: 0xBFC5_737C_C901_8CDD, 0x3C60_0B28_EF01_3C72), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_D50A_012D_50A0), logarithm: .init(bits: 0xBFC4_DC7B_897B_C1C7, 0xBC4B_60AE_1FF0_E82E), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_BEF9_8E5A_3711), logarithm: .init(bits: 0xBFC4_462B_9DC9_B3DC, 0x3C48_5388_D830_C709), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_A91C_92F3_C105), logarithm: .init(bits: 0xBFC3_B08B_6757_F2A7, 0xBC65_E1AD_9BE0_A4CD), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_9372_5BB8_04A5), logarithm: .init(bits: 0xBFC3_1B99_4D3A_4F86, 0x3C61_238B_5EFE_0665), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_7DFA_38A1_CE4D), logarithm: .init(bits: 0xBFC2_8753_BC11_ABA2, 0x3C67_394D_9FA3_3313), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_68B3_7CD6_0127), logarithm: .init(bits: 0xBFC1_F3B9_25F2_5D44, 0xBC60_8B27_BE4E_6B15), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_539D_7E91_77B2), logarithm: .init(bits: 0xBFC1_60C8_024B_27B0, 0x3C43_55BF_D870_AFEB), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_3EB7_9717_605B), logarithm: .init(bits: 0xBFC0_CE7E_CDCC_C28B, 0xBC41_B57F_EA88_DA98), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_2A01_22A0_122A), logarithm: .init(bits: 0xBFC0_3CDC_0A51_EC0D, 0xBC61_9E2D_3F8B_7D10), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_1579_8048_55E6), logarithm: .init(bits: 0xBFBF_57BC_7D90_05DB, 0x3C5D_3615_74FB_24E2), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF2_0120_1201_2012), logarithm: .init(bits: 0xBFBE_3707_EE30_487B, 0xBC49_399D_9AAF_3B33), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_ECF4_3C7F_B84C), logarithm: .init(bits: 0xBFBD_1797_8821_9362, 0x3C5B_1284_1044_A96C), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_D8F5_672E_4ABD), logarithm: .init(bits: 0xBFBB_F968_769F_CA18, 0x3C50_6E4F_B7AF_9C69), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_C522_FC1C_E059), logarithm: .init(bits: 0xBFBA_DC77_EE5A_EA8E, 0xBC5D_7D8F_39BE_E658), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_B17C_67F2_BAE3), logarithm: .init(bits: 0xBFB9_C0C3_2D4D_254D, 0x3C56_27A0_E199_F569), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_9E01_19E0_119E), logarithm: .init(bits: 0xBFB8_A647_7A91_DC29, 0x3C53_D419_0A48_2421), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_8AB0_8390_2BDB), logarithm: .init(bits: 0xBFB7_8D02_263D_82D7, 0xBC5C_BCA5_B4FD_B87E), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_778A_191B_D684), logarithm: .init(bits: 0xBFB6_74F0_8936_5A78, 0xBC4C_A64E_9980_E048), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_648D_50FC_3201), logarithm: .init(bits: 0xBFB5_5E10_050E_0382, 0xBC59_A062_9E39_73E4), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_51B9_A3FD_D5C9), logarithm: .init(bits: 0xBFB4_485E_03DB_DFB0, 0xBC53_BA34_9AAD_BC6D), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_3F0E_8D34_4724), logarithm: .init(bits: 0xBFB3_33D7_F818_3F4A, 0x3C4A_DAA0_6E21_1E9E), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_2C8B_89ED_C0AC), logarithm: .init(bits: 0xBFB2_207B_5C78_54A1, 0xBC5B_3F04_31EF_B154), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_1A30_19A7_4826), logarithm: .init(bits: 0xBFB1_0E45_B3CA_E829, 0xBC59_B5ED_72E6_D974), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF1_07FB_BE01_1080), logarithm: .init(bits: 0xBFAF_FA69_11AB_9309, 0x3C4C_D9F1_F95C_2EF1), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_F5ED_FAB3_25A2), logarithm: .init(bits: 0xBFAD_DA8A_DC67_EE59, 0x3C43_1936_790B_B3B2), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_E406_5582_6011), logarithm: .init(bits: 0xBFAB_BCEB_FC68_F424, 0x3C4C_D186_2F85_4848), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_D244_5635_9E3A), logarithm: .init(bits: 0xBFA9_A187_B573_DE81, 0xBBFB_13B2_6F29_8A6A), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_C0A7_868B_4171), logarithm: .init(bits: 0xBFA7_8859_5A35_77C8, 0xBC12_F7C4_C5B3_C8BD), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_AF2F_722E_ECB5), logarithm: .init(bits: 0xBFA5_715C_4C03_CEE1, 0xBC45_101D_C4EB_F91F), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_9DDB_A6AF_8360), logarithm: .init(bits: 0xBFA3_5C8B_FAA1_3069, 0x3C05_0830_A655_43A8), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_8CAB_B375_65E2), logarithm: .init(bits: 0xBFA1_49E3_E400_5A8D, 0x3C3A_9A41_68FC_EBEB), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_7B9F_29B8_EAE2), logarithm: .init(bits: 0xBF9E_72BF_2813_CE6A, 0x3C38_A4BB_A6A3_54FA), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_6AB5_9C79_12FB), logarithm: .init(bits: 0xBF9A_55F5_48C5_C427, 0xBC2F_60D2_FC36_A0D9), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_59EE_A072_7586), logarithm: .init(bits: 0xBF96_3D61_7869_0BBE, 0x3C31_8ED4_D357_C9DC), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_4949_CC16_64C5), logarithm: .init(bits: 0xBF92_28FB_1FEA_2E0A, 0xBC23_2849_91FE_3D5C), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_38C6_B782_47FC), logarithm: .init(bits: 0xBF8C_3173_84C7_5F0D, 0xBC28_0620_8C04_C21F), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_2864_FC77_29E9), logarithm: .init(bits: 0xBF84_1929_F968_330C, 0xBC23_AAE8_09B4_3DD0), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_1824_3651_7A37), logarithm: .init(bits: 0xBF78_1212_1458_6B02, 0x3C1C_7D68_C0D9_10F2), halved: true),
        .init(inverse: Double(bitPattern: 0x3FF0_0000_0000_0000), logarithm: .init(bits: 0x0000_0000_0000_0000, 0x0000_0000_0000_0000), halved: true),
    ]
}
