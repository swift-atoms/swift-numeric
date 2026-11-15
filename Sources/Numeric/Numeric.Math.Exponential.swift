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
        r += Numeric.Math.Pair.product(-k, step[1])
        r += -k * step[2]
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
        r += Numeric.Math.Pair.product(-k, step[1])
        r += -k * step[2]
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

    static let inverse = Double(bitPattern: 0x4067_1547_652B_82FE)

    static let step: [Double] = [Double(bitPattern: 0x3F76_2E42_FF00_0000), Double(bitPattern: 0xBD57_1843_2A20_0000), Double(bitPattern: 0x3B33_C767_3007_E5ED)]

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

    static let powers: [Numeric.Math.Pair] = [
        .init(bits: 0x3FF0_0000_0000_0000, 0x0000_0000_0000_0000),
        .init(bits: 0x3FF0_163D_A9FB_3335, 0x3C9B_6129_9AB8_CDB7),
        .init(bits: 0x3FF0_2C9A_3E77_8061, 0xBC71_9083_535B_085D),
        .init(bits: 0x3FF0_4315_E86E_7F85, 0xBC90_A31C_1977_C96E),
        .init(bits: 0x3FF0_59B0_D315_8574, 0x3C8D_73E2_A475_B465),
        .init(bits: 0x3FF0_706B_29DD_F6DE, 0xBC8C_91DF_E2B1_3C27),
        .init(bits: 0x3FF0_8745_1875_9BC8, 0x3C61_86BE_4BB2_84FF),
        .init(bits: 0x3FF0_9E3E_CAC6_F383, 0x3C91_4878_1831_6136),
        .init(bits: 0x3FF0_B558_6CF9_890F, 0x3C98_A62E_4ADC_610B),
        .init(bits: 0x3FF0_CC92_2B72_47F7, 0x3C90_1EDC_16E2_4F71),
        .init(bits: 0x3FF0_E3EC_32D3_D1A2, 0x3C40_3A17_27C5_7B53),
        .init(bits: 0x3FF0_FB66_AFFE_D31B, 0xBC6B_9BED_C44E_BD7B),
        .init(bits: 0x3FF1_1301_D012_5B51, 0xBC96_C510_3944_9B3A),
        .init(bits: 0x3FF1_2ABD_C06C_31CC, 0xBC51_B514_B36C_A5C7),
        .init(bits: 0x3FF1_429A_AEA9_2DE0, 0xBC93_2FBF_9AF1_369E),
        .init(bits: 0x3FF1_5A98_C8A5_8E51, 0x3C82_406A_B9EE_AB0A),
        .init(bits: 0x3FF1_72B8_3C7D_517B, 0xBC81_9041_B9D7_8A76),
        .init(bits: 0x3FF1_8AF9_388C_8DEA, 0xBC91_1023_D197_0F6C),
        .init(bits: 0x3FF1_A35B_EB6F_CB75, 0x3C8E_5B4C_7B49_68E4),
        .init(bits: 0x3FF1_BBE0_8404_5CD4, 0xBC99_5386_352E_F607),
        .init(bits: 0x3FF1_D487_3168_B9AA, 0x3C9E_016E_00A2_643C),
        .init(bits: 0x3FF1_ED50_22FC_D91D, 0xBC91_DF98_027B_B78C),
        .init(bits: 0x3FF2_063B_8862_8CD6, 0x3C8D_C775_814A_8495),
        .init(bits: 0x3FF2_1F49_917D_DC96, 0x3C82_A97E_9494_A5EE),
        .init(bits: 0x3FF2_387A_6E75_6238, 0x3C99_B07E_B6C7_0573),
        .init(bits: 0x3FF2_51CE_4FB2_A63F, 0x3C8A_C155_BEF4_F4A4),
        .init(bits: 0x3FF2_6B45_65E2_7CDD, 0x3C82_BD33_9940_E9D9),
        .init(bits: 0x3FF2_84DF_E1F5_6381, 0xBC9A_4C3A_8C3F_0D7E),
        .init(bits: 0x3FF2_9E9D_F51F_DEE1, 0x3C86_12E8_AFAD_1255),
        .init(bits: 0x3FF2_B87F_D0DA_D990, 0xBC41_0ADC_D638_1AA4),
        .init(bits: 0x3FF2_D285_A6E4_030B, 0x3C90_0247_54DB_41D5),
        .init(bits: 0x3FF2_ECAF_A93E_2F56, 0x3C71_CA0F_45D5_2383),
        .init(bits: 0x3FF3_06FE_0A31_B715, 0x3C86_F46A_D231_82E4),
        .init(bits: 0x3FF3_2170_FC4C_D831, 0x3C8A_9CE7_8E18_047C),
        .init(bits: 0x3FF3_3C08_B264_16FF, 0x3C93_2721_8436_59A6),
        .init(bits: 0x3FF3_56C5_5F92_9FF1, 0xBC8B_5CEE_5C4E_4628),
        .init(bits: 0x3FF3_71A7_373A_A9CB, 0xBC96_3AEA_BF42_EAE2),
        .init(bits: 0x3FF3_8CAE_6D05_D866, 0xBC9E_958D_3C99_04BD),
        .init(bits: 0x3FF3_A7DB_34E5_9FF7, 0xBC75_E436_D661_F5E3),
        .init(bits: 0x3FF3_C32D_C313_A8E5, 0xBC9E_FFF8_375D_29C3),
        .init(bits: 0x3FF3_DEA6_4C12_3422, 0x3C8A_DA09_11F0_9EBC),
        .init(bits: 0x3FF3_FA45_04AC_801C, 0xBC97_D023_F956_F9F3),
        .init(bits: 0x3FF4_160A_21F7_2E2A, 0xBC5E_F369_1C30_9278),
        .init(bits: 0x3FF4_31F5_D950_A897, 0xBC81_C7DD_E35F_7999),
        .init(bits: 0x3FF4_4E08_6061_892D, 0x3C48_9B7A_04EF_80D0),
        .init(bits: 0x3FF4_6A41_ED1D_0057, 0x3C9C_944B_D164_8A76),
        .init(bits: 0x3FF4_86A2_B5C1_3CD0, 0x3C73_C1A3_B690_62F0),
        .init(bits: 0x3FF4_A32A_F0D7_D3DE, 0x3C99_CB62_F3D1_BE56),
        .init(bits: 0x3FF4_BFDA_D536_2A27, 0x3C7D_4397_AFEC_42E2),
        .init(bits: 0x3FF4_DCB2_99FD_DD0D, 0x3C98_ECDB_BC6A_7833),
        .init(bits: 0x3FF4_F9B2_769D_2CA7, 0xBC94_B309_D259_57E3),
        .init(bits: 0x3FF5_16DA_A2CF_6642, 0xBC8F_7685_69BD_93EF),
        .init(bits: 0x3FF5_342B_569D_4F82, 0xBC80_7ABE_1DB1_3CAD),
        .init(bits: 0x3FF5_51A4_CA5D_920F, 0xBC8D_689C_EFED_E59B),
        .init(bits: 0x3FF5_6F47_36B5_27DA, 0x3C99_BB2C_011D_93AD),
        .init(bits: 0x3FF5_8D12_D497_C7FD, 0x3C82_95E1_5B9A_1DE8),
        .init(bits: 0x3FF5_AB07_DD48_5429, 0x3C96_324C_0546_47AD),
        .init(bits: 0x3FF5_C926_8A59_46B7, 0x3C3C_4B1B_8169_86A2),
        .init(bits: 0x3FF5_E76F_15AD_2148, 0x3C9B_A6F9_3080_E65E),
        .init(bits: 0x3FF6_05E1_B976_DC09, 0xBC93_E242_9B56_DE47),
        .init(bits: 0x3FF6_247E_B03A_5585, 0xBC93_83C1_7E40_B497),
        .init(bits: 0x3FF6_4346_34CC_C320, 0xBC8C_483C_759D_8933),
        .init(bits: 0x3FF6_6238_8255_2225, 0xBC9B_B609_8759_1C34),
        .init(bits: 0x3FF6_8155_D44C_A973, 0x3C60_38AE_44F7_3E65),
        .init(bits: 0x3FF6_A09E_667F_3BCD, 0xBC9B_DD34_13B2_6456),
        .init(bits: 0x3FF6_C012_750B_DABF, 0xBC72_8956_67FF_0B0D),
        .init(bits: 0x3FF6_DFB2_3C65_1A2F, 0xBC6B_BE3A_683C_88AB),
        .init(bits: 0x3FF6_FF7D_F951_9484, 0xBC88_3C0F_2586_0EF6),
        .init(bits: 0x3FF7_1F75_E8EC_5F74, 0xBC81_6E47_8688_7A99),
        .init(bits: 0x3FF7_3F9A_48A5_8174, 0xBC90_A8D9_6C65_D53C),
        .init(bits: 0x3FF7_5FEB_5642_67C9, 0xBC90_2459_5731_6DD3),
        .init(bits: 0x3FF7_8069_4FDE_5D3F, 0x3C98_66B8_0A02_162D),
        .init(bits: 0x3FF7_A114_73EB_0187, 0xBC84_1577_EE04_992F),
        .init(bits: 0x3FF7_C1ED_0130_C132, 0x3C9F_124C_D116_4DD6),
        .init(bits: 0x3FF7_E2F3_36CF_4E62, 0x3C70_5D02_BA15_797E),
        .init(bits: 0x3FF8_0427_543E_1A12, 0xBC92_7C86_626D_972B),
        .init(bits: 0x3FF8_2589_994C_CE13, 0xBC9D_4C1D_D415_32D8),
        .init(bits: 0x3FF8_471A_4623_C7AD, 0xBC88_D684_A341_CDFB),
        .init(bits: 0x3FF8_68D9_9B44_92ED, 0xBC9F_C6F8_9BD4_F6BA),
        .init(bits: 0x3FF8_8AC7_D98A_6699, 0x3C99_94C2_F37C_B53A),
        .init(bits: 0x3FF8_ACE5_422A_A0DB, 0x3C96_E9F1_5686_4B27),
        .init(bits: 0x3FF8_CF32_16B5_448C, 0xBC70_D55E_32E9_E3AA),
        .init(bits: 0x3FF8_F1AE_9915_7736, 0x3C85_CC13_A2E3_976C),
        .init(bits: 0x3FF9_145B_0B91_FFC6, 0xBC9D_D679_2E58_2524),
        .init(bits: 0x3FF9_3737_B0CD_C5E5, 0xBC67_5FC7_81B5_7EBC),
        .init(bits: 0x3FF9_5A44_CBC8_520F, 0xBC76_4B7C_96A5_F039),
        .init(bits: 0x3FF9_7D82_9FDE_4E50, 0xBC9D_185B_7C1B_85D1),
        .init(bits: 0x3FF9_A0F1_70CA_07BA, 0xBC91_73BD_91CE_E632),
        .init(bits: 0x3FF9_C491_82A3_F090, 0x3C7C_7C46_B071_F2BE),
        .init(bits: 0x3FF9_E863_19E3_2323, 0x3C78_24CA_78E6_4C6E),
        .init(bits: 0x3FFA_0C66_7B5D_E565, 0xBC93_5949_5D1C_D533),
        .init(bits: 0x3FFA_309B_EC4A_2D33, 0x3C96_305C_7DDC_36AB),
        .init(bits: 0x3FFA_5503_B23E_255D, 0xBC9D_2F6E_DB8D_41E1),
        .init(bits: 0x3FFA_799E_1330_B358, 0x3C9B_CB7E_CAC5_63C7),
        .init(bits: 0x3FFA_9E6B_5579_FDBF, 0x3C90_FAC9_0EF7_FD31),
        .init(bits: 0x3FFA_C36B_BFD3_F37A, 0xBC8F_9234_CAE7_6CD0),
        .init(bits: 0x3FFA_E89F_995A_D3AD, 0x3C97_A1CD_345D_CC81),
        .init(bits: 0x3FFB_0E07_298D_B666, 0xBC9B_DEF5_4C80_E425),
        .init(bits: 0x3FFB_33A2_B84F_15FB, 0xBC62_805E_3084_D708),
        .init(bits: 0x3FFB_5972_8DE5_593A, 0xBC9C_71DF_BBBA_6DE3),
        .init(bits: 0x3FFB_7F76_F2FB_5E47, 0xBC75_584F_7E54_AC3B),
        .init(bits: 0x3FFB_A5B0_30A1_064A, 0xBC9E_FCD3_0E54_292E),
        .init(bits: 0x3FFB_CC1E_904B_C1D2, 0x3C82_3DD0_7A2D_9E84),
        .init(bits: 0x3FFB_F2C2_5BD7_1E09, 0xBC9E_FDCA_3F6B_9C73),
        .init(bits: 0x3FFC_199B_DD85_529C, 0x3C81_1065_8950_48DD),
        .init(bits: 0x3FFC_40AB_5FFF_D07A, 0x3C9B_4537_E083_C60A),
        .init(bits: 0x3FFC_67F1_2E57_D14B, 0x3C92_884D_FF48_3CAD),
        .init(bits: 0x3FFC_8F6D_9406_E7B5, 0x3C71_ACBC_4880_5C44),
        .init(bits: 0x3FFC_B720_DCEF_9069, 0x3C75_03CB_D1E9_49DB),
        .init(bits: 0x3FFC_DF0B_555D_C3FA, 0xBC8D_D83B_5382_9D72),
        .init(bits: 0x3FFD_072D_4A07_897C, 0xBC9C_BC37_4379_7A9C),
        .init(bits: 0x3FFD_2F87_080D_89F2, 0xBC9D_487B_719D_8578),
        .init(bits: 0x3FFD_5818_DCFB_A487, 0x3C82_ED02_D75B_3707),
        .init(bits: 0x3FFD_80E3_16C9_8398, 0xBC91_1EC1_8BED_DFE8),
        .init(bits: 0x3FFD_A9E6_03DB_3285, 0x3C9C_2300_696D_B532),
        .init(bits: 0x3FFD_D321_F301_B460, 0x3C92_DA57_78F0_18C3),
        .init(bits: 0x3FFD_FC97_337B_9B5F, 0xBC91_A5CD_4F18_4B5C),
        .init(bits: 0x3FFE_2646_14F5_A129, 0xBC97_B627_817A_1496),
        .init(bits: 0x3FFE_502E_E78B_3FF6, 0x3C83_9E89_80A9_CC8F),
        .init(bits: 0x3FFE_7A51_FBC7_4C83, 0x3C92_D522_CA0C_8DE2),
        .init(bits: 0x3FFE_A4AF_A2A4_90DA, 0xBC9E_9C23_179C_2893),
        .init(bits: 0x3FFE_CF48_2D8E_67F1, 0xBC9C_93F3_B411_AD8C),
        .init(bits: 0x3FFE_FA1B_EE61_5A27, 0x3C9D_C7F4_86A4_B6B0),
        .init(bits: 0x3FFF_252B_376B_BA97, 0x3C93_A1A5_BF0D_8E43),
        .init(bits: 0x3FFF_5076_5B6E_4540, 0x3C99_D3E1_2DD8_A18B),
        .init(bits: 0x3FFF_7BFD_AD9C_BE14, 0xBC9D_BB12_D006_350A),
        .init(bits: 0x3FFF_A7C1_819E_90D8, 0x3C87_4853_F3A5_931E),
        .init(bits: 0x3FFF_D3C2_2B8F_71F1, 0x3C62_EB74_9665_79E7),
    ]
}
