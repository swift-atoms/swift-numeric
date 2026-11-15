import Testing

@testable import Numeric

@Suite
struct `Correctly Rounded Tests` {
    static let references: [(Swift.String, UInt64, UInt64)] = [
        ("exp", 0xC080_7096_16EF_F928, 0x1080_6978_E449_7E19),
        ("exp", 0x4083_7202_5AEF_263E, 0x780A_548A_0D2C_37BF),
        ("exp", 0x404E_B816_AD64_9AC0, 0x4578_DFC7_EEC6_C70E),
        ("exp", 0x4072_7CEB_C818_2966, 0x5A9B_190B_6E36_5A4B),
        ("exp", 0xC053_E82E_EAE5_C040, 0x38C1_6734_6DDF_1D63),
        ("exp", 0x407F_430C_583F_4D20, 0x6D08_A168_3E20_2C5F),
        ("exp", 0x4084_5342_A95E_8018, 0x7A94_3FA0_AE1D_EF2D),
        ("exp", 0x4083_7BE7_0391_77A2, 0x7826_ABB2_BEB8_EB16),
        ("exp", 0xC074_F1D9_76CD_3ABC, 0x21B7_1BF6_CACA_3149),
        ("exp", 0x4084_105F_E6E1_4DF8, 0x79D3_65AC_3617_70FF),
        ("exp", 0x4057_0C9F_4DED_4C18, 0x4840_2393_928B_AD23),
        ("exp", 0x4067_6F25_855D_34D4, 0x50D6_1D02_92E6_6150),
        ("exp", 0x404E_7892_302F_0DA0, 0x456E_49AD_EBD5_6738),
        ("exp", 0xC019_9ABF_BE4A_0580, 0x3F5B_3142_CC1E_F43B),
        ("exp", 0x4049_7F22_9C37_66D0, 0x4487_B6EB_EFDE_5B5A),
        ("exp", 0x4082_5308_3791_AD54, 0x74CF_41B6_582B_A60F),
        ("exp", 0xC058_045F_3BB6_05A8, 0x3745_26E9_2AE1_AA03),
        ("exp", 0x4075_E092_692B_67EC, 0x5F7F_E2B6_CA12_F17B),
        ("exp", 0xC082_99A0_3455_CF89, 0x0A43_BE2C_3211_63E2),
        ("exp", 0xC07A_F03A_0CF0_FCD2, 0x1912_19D5_9DCC_1F6B),
        ("exp", 0xC080_813E_3DBC_5952, 0x1050_5E4B_ADCE_59BD),
        ("exp", 0xC048_E447_5FAD_A510, 0x3B72_18E2_8033_0E3D),
        ("exp", 0xC050_9C90_D695_5318, 0x39F1_9BC2_25AE_1E7E),
        ("exp", 0x4081_0F6D_945C_3DF2, 0x7128_6466_F81C_F2B8),
        ("exp", 0x4067_99C1_EAF1_15D4, 0x50F4_EFA7_5C5D_2603),
        ("exp", 0x4080_1A1B_8130_2B6E, 0x6E64_A620_5D34_3E75),
        ("exp", 0x4040_3A12_A99E_9520, 0x42DC_4308_D045_56EF),
        ("exp", 0x4075_1C0A_A4EA_692C, 0x5E63_58B2_E395_771C),
        ("exp", 0x406D_FF3B_EDC0_83A0, 0x5592_8949_7DF4_62C5),
        ("exp", 0xC083_12D9_0F70_D711, 0x08E5_BE13_AFA6_45A7),
        ("exp", 0x4076_985B_8638_FDE4, 0x6087_B1D9_8063_9C3D),
        ("exp", 0x405F_E285_CB1F_3CB0, 0x4B70_015F_34F0_0F6B),
        ("exp", 0xC071_639A_BBB7_C92C, 0x26D8_5944_AC63_4864),
        ("exp", 0xC084_84AB_1B2F_0055, 0x04BA_E971_3093_CF66),
        ("exp", 0x407F_FBCF_6342_68A0, 0x6E13_7477_3984_DE9A),
        ("exp", 0xC043_135D_01F5_9C70, 0x3C7F_1C5D_43F0_0329),
        ("exp", 0xC087_490A_3D70_A3D7, 0x0000_0000_0000_0001),
        ("exp", 0xC086_8400_0000_0000, 0x0000_0005_CF08_FFF0),
        ("exp", 0x4086_2E3D_70A3_D70A, 0x7FEF_E9CE_5C4C_52B4),
        ("exp", 0x01A5_6E1F_C2F8_F359, 0x3FF0_0000_0000_0000),
        ("exp", 0x3FE0_0000_0000_0000, 0x3FFA_6129_8E1E_069C),
        ("log", 0x401C_45C0_07BD_89D9, 0x3FFF_4A1C_CD67_42CE),
        ("log", 0x4017_A5D1_1410_D3F4, 0x3FFC_6E7A_9EA9_2EFB),
        ("log", 0x3FD2_DC93_241F_7FB0, 0xBFF3_8C4D_D22F_6D0F),
        ("log", 0x3FEA_FB9C_5F6E_8DC4, 0xBFC5_D410_EFC4_85D3),
        ("log", 0x4014_D5FB_3FBD_CE14, 0x3FFA_67F6_5901_5FE0),
        ("log", 0x4020_ABC2_6437_A95D, 0x4000_F6D2_FAC6_17F5),
        ("log", 0x4015_86F4_8814_F6B6, 0x3FFA_EDA7_E385_514F),
        ("log", 0x4014_6332_AE9D_EC02, 0x3FFA_0EDB_6A3E_08EF),
        ("log", 0x3FE7_4287_A13B_F240, 0xBFD4_6A97_6A54_86DC),
        ("log", 0x3FFC_CFDF_0280_33F6, 0x3FE2_D28F_5D48_C1D1),
        ("log", 0x3FFB_49E6_7A5C_CF36, 0x3FE1_1591_C690_6272),
        ("log", 0x4000_CF68_AA6C_CB4A, 0x3FE7_C2EB_2039_D2EB),
        ("log", 0x3FE7_D1D3_031B_215E, 0xBFD2_E4FB_C0FD_549B),
        ("log", 0x4016_943B_251A_D473, 0x3FFB_B10E_ED78_329F),
        ("log", 0x400A_048B_11EC_1AFA, 0x3FF2_DE90_D52A_0436),
        ("log", 0x4018_257B_6B38_3EEC, 0x3FFC_C3F5_7D4E_2D36),
        ("log", 0x3FDA_B66B_9AB8_9224, 0xBFEB_F5BF_649B_F53B),
        ("log", 0x400A_CC86_F39C_7587, 0x3FF3_57BD_1A2B_F945),
        ("log", 0x4022_7C3E_1C56_62F6, 0x4001_CA67_50BB_771D),
        ("log", 0x3FE9_7BB7_D84C_7F1E, 0xBFCD_25B8_0554_F6AC),
        ("log", 0x4022_8E36_940D_740A, 0x4001_D22A_83FB_1F2D),
        ("log", 0x3FC2_D806_374D_A2D8, 0xBFFE_A74B_F8BB_E9DB),
        ("log", 0x4010_728A_1047_BF8F, 0x3FF6_9F3A_91B1_00EF),
        ("log", 0x3FF7_8002_47F4_9ABC, 0x3FD8_9A39_BD19_C0B3),
        ("log", 0x6518_8BAF_AD2B_8ED5, 0x4079_C284_979D_543E),
        ("log", 0x52F9_5918_6876_FB5C, 0x406A_65A8_CC17_9314),
        ("log", 0x041A_E966_19D4_DAAA, 0xC084_BC1E_C5F8_4FBD),
        ("log", 0x268D_B3D1_148F_32F6, 0xC071_97E0_4F39_7B62),
        ("log", 0x504B_2D87_D5B8_A57C, 0x4066_AE1E_89DF_1D63),
        ("log", 0x176F_6F22_F515_6258, 0xC07C_12D5_DF22_707B),
        ("log", 0x32CB_6BCB_654F_9F2A, 0xC062_36E4_0004_88D2),
        ("log", 0x411A_20AB_57A9_C884, 0x4029_EF21_9C7D_D8DD),
        ("log", 0x0CF4_8F2F_8E3F_B5EC, 0xC081_AADB_E6C1_1920),
        ("log", 0x7887_B647_1FB5_37F3, 0x4083_9D88_6154_AAFD),
        ("log", 0x0DC1_6A91_F2B0_2B48, 0xC081_6419_54CB_AC86),
        ("log", 0x2356_9140_6BCB_5030, 0xC073_D1E1_3EC6_ADC4),
        ("log", 0x0000_0000_0000_0001, 0xC087_4385_446D_71C3),
        ("log", 0x0000_1268_8B70_E62B, 0xC086_4E69_394D_9508),
        ("log", 0x7FEF_FFFF_FFFF_FFFF, 0x4086_2E42_FEFA_39EF),
        ("log", 0x3FF0_0000_0000_0001, 0x3CAF_FFFF_FFFF_FFFF),
        ("log", 0x3FEF_FFFF_FFFF_FFFF, 0xBCA0_0000_0000_0000),
        ("sin", 0xC046_7FBB_A73B_C1CF, 0xBFEB_319C_4A0C_5623),
        ("sin", 0x4044_0ED3_74EF_2B80, 0x3FE5_37A5_B5EB_2549),
        ("sin", 0x4057_C1C4_D673_A45C, 0x3FE6_8072_3978_C0A3),
        ("sin", 0x4054_8933_AAD6_188C, 0x3FDC_8C69_8798_12AB),
        ("sin", 0x4051_D6EC_B663_F99C, 0x3FE9_0907_25FE_0BDA),
        ("sin", 0xC054_373E_824B_7A32, 0x3FE7_5B95_089B_F2DA),
        ("sin", 0x4051_E499_F04B_F2DE, 0x3FE4_3D2D_A249_A111),
        ("sin", 0x4054_267C_EFAD_0DC0, 0xBFEC_3920_AE71_F3A2),
        ("sin", 0xC051_6458_8547_7D6F, 0xBFDC_00B4_A4AE_6E7D),
        ("sin", 0x402D_03CE_6A41_CF80, 0x3FED_D4D5_692E_5F4D),
        ("sin", 0xC035_2918_C797_0078, 0xBFE7_A087_4588_30DF),
        ("sin", 0xC003_5A87_4854_53E0, 0xBFE5_2861_0A71_AB1F),
        ("sin", 0xC04B_D99B_8964_32AE, 0x3FE8_02F5_F309_644C),
        ("sin", 0xC04C_8FF9_82D1_4B32, 0xBFE1_6EE3_976D_7187),
        ("sin", 0xC052_9851_D3EB_9968, 0x3FEB_3CDD_C657_47FD),
        ("sin", 0xC051_0F33_D97F_1556, 0x3FE8_9CD1_5363_1519),
        ("sin", 0x4049_9BFB_DF8E_6E20, 0x3FEA_166F_E6F9_2752),
        ("sin", 0x4050_453D_833E_1C36, 0x3FE8_E5D7_07A8_8A8A),
        ("sin", 0xC046_183D_17E5_BB4C, 0xBFCA_50CB_DAE3_BA00),
        ("sin", 0xC047_3086_8EAE_516D, 0xBFE5_B0A4_0EA1_59EF),
        ("sin", 0xC055_F55C_ABC2_31EC, 0x3FC0_B244_FFBC_2ABD),
        ("sin", 0xC039_F202_5112_CAB4, 0xBFE7_3C10_4308_3818),
        ("sin", 0x4050_9826_FB3C_6C5A, 0xBFD9_278A_35B0_9082),
        ("sin", 0x4054_9B45_0A32_75AC, 0x3FE5_B004_5894_A092),
        ("sin", 0xC12C_51CC_A5C7_0CFA, 0x3FEE_79FF_718B_7209),
        ("sin", 0xC12E_137D_10BF_8AA7, 0x3FED_EE96_D537_F7A6),
        ("sin", 0xC127_EB22_C6B0_B69A, 0xBF76_C3EA_8DDF_00D3),
        ("sin", 0x40F1_5F45_69C7_4700, 0xBFE5_7725_2F68_83A9),
        ("sin", 0x412B_65FD_F8F7_246C, 0xBFE6_DD32_D5EA_508B),
        ("sin", 0x412C_C612_A1EC_2010, 0x3FE2_65ED_041E_7BFB),
        ("sin", 0xC119_701C_CF75_1CE2, 0x3FEB_AE49_624D_AE27),
        ("sin", 0xC11C_E296_5CB1_9906, 0x3FE9_AEA8_769C_F6FC),
        ("sin", 0x4480_F0CF_064D_D592, 0xBFEB_453A_B76B_F397),
        ("sin", 0x7506_AC5B_262C_A1FF, 0x3FF0_0000_0000_0000),
        ("sin", 0xFE37_E43C_8800_759C, 0x3FEA_2C16_B010_E385),
        ("sin", 0x3FF9_21FB_5444_2D18, 0x3FF0_0000_0000_0000),
        ("sin", 0x4009_21FB_5444_2D18, 0x3CA1_A626_3314_5C07),
        ("sin", 0x8000_0000_0000_0001, 0x8000_0000_0000_0001),
        ("sin", 0x41CD_CD65_0000_0000, 0x3FE1_778C_AE83_C69B),
        ("cos", 0xC051_911F_4845_A20D, 0x3FD9_FF4F_B16A_C511),
        ("cos", 0xC051_614B_D555_EE90, 0x3FED_6897_A0B0_5998),
        ("cos", 0xC057_5264_F897_CB10, 0x3FE2_57D0_5081_C695),
        ("cos", 0xC042_47FA_CFDF_E51D, 0x3FDA_E9EA_4E52_CDB3),
        ("cos", 0xC001_51A0_4525_1920, 0xBFE1_E94F_3DB4_FA19),
        ("cos", 0x4054_DA0D_7472_1AEA, 0xBFC3_BE62_B218_4DFD),
        ("cos", 0x404B_241A_850B_7B60, 0xBFE4_8325_43F9_170B),
        ("cos", 0x4042_63F6_6F5C_5260, 0x3FE3_6EE7_429E_3D56),
        ("cos", 0xC054_3A37_D4DB_9056, 0x3FE6_EF20_BF94_6CDB),
        ("cos", 0xC016_1C68_A410_F1C0, 0x3FE7_4B84_332D_03CC),
        ("cos", 0xC058_EEEA_AAF7_0FBC, 0x3FE6_57CC_03D6_FBE9),
        ("cos", 0xC023_5516_0698_A880, 0xBFEF_1274_9F01_ECDF),
        ("cos", 0xC04F_5914_26A4_E7A0, 0x3FEF_B470_8EDF_5637),
        ("cos", 0xC051_938D_6CAD_7B2E, 0x3FD7_C226_1650_4096),
        ("cos", 0x4057_4BDE_B560_6986, 0x3FDF_289E_D655_4A48),
        ("cos", 0x4046_8CCE_8316_38A4, 0x3FDC_034F_2F16_EDC1),
        ("cos", 0xC051_7C35_BCAB_008E, 0x3FE5_B246_8234_AFEE),
        ("cos", 0x404E_E794_2BCE_0E80, 0x3FE0_ACF1_BE2F_1063),
        ("cos", 0x4053_C2F9_125F_D288, 0xBFEB_FAEF_BCED_7954),
        ("cos", 0xC051_75CE_1589_8C88, 0x3FE7_F017_E715_D5C9),
        ("cos", 0x404F_E6FA_0B55_DB40, 0x3FE2_04FD_FCCA_BBFF),
        ("cos", 0xC055_C0D1_1307_7282, 0x3FE2_90EC_432B_BBDA),
        ("cos", 0x4051_F30D_25EF_DB60, 0xBFEC_B043_8C8D_81F0),
        ("cos", 0x4025_81CA_FC14_01A0, 0xBFCE_AEFD_0CA7_87DF),
        ("cos", 0xC12A_D9BD_F51E_0195, 0xBFC5_EF16_7537_C771),
        ("cos", 0x410F_16D1_BE82_45B0, 0x3FED_47E8_8AB7_DBE2),
        ("cos", 0xC0F0_7AB2_3FEC_B098, 0x3FDB_EEC6_D4FB_5737),
        ("cos", 0x4115_E28B_2F2E_9A98, 0x3FEE_EC59_06E9_4CD2),
        ("cos", 0xC111_FEF8_22BB_6018, 0x3FD2_5682_6D11_0E96),
        ("cos", 0x4119_4331_FEB3_8C68, 0xBFD7_AE19_8E21_D9BD),
        ("cos", 0x411D_0E92_5063_5EDC, 0xBFDF_B3D6_5606_6BA5),
        ("cos", 0xC12D_29E6_1FC0_DF86, 0x3FEE_CA29_E4C5_E668),
        ("cos", 0x4480_F0CF_064D_D592, 0x3FE0_BE2C_EF01_C8F4),
        ("cos", 0x7506_AC5B_262C_A1FF, 0xBC21_4AE7_2E6B_A22F),
        ("cos", 0xFE37_E43C_8800_759C, 0xBFE2_6990_22AD_C4C1),
        ("cos", 0x3FF9_21FB_5444_2D18, 0x3C91_A626_3314_5C07),
        ("cos", 0x4009_21FB_5444_2D18, 0xBFF0_0000_0000_0000),
        ("cos", 0x8000_0000_0000_0001, 0x3FF0_0000_0000_0000),
        ("cos", 0x41CD_CD65_0000_0000, 0x3FEA_CFF8_C736_4234),
    ]

    static func value(_ name: Swift.String, _ x: Double) -> Double {
        switch name {
        case "exp": Double.math.exp(x)
        case "log": Double.math.log(x)
        case "sin": Double.math.sin(x)
        default: Double.math.cos(x)
        }
    }

    @Test
    func `exp, log, sin and cos give the correctly rounded value, the same bits on every platform`() {
        for (name, argument, expected) in Self.references {
            let x = Double(bitPattern: argument)
            #expect(Self.value(name, x).bitPattern == expected, "\(name)(\(x))")
        }
    }

    @Test
    func `the quick path of each function gives exactly what the exact path gives`() {
        var state: UInt64 = 0x5EED
        for _ in 0..<10_000 {
            state &+= 0x9E37_79B9_7F4A_7C15
            var bits = (state ^ (state >> 30)) &* 0xBF58_476D_1CE4_E5B9
            bits = (bits ^ (bits >> 27)) &* 0x94D0_49BB_1331_11EB
            bits ^= bits >> 31
            let unit = Double(bits >> 11) * 0x1p-53
            let exponent = Double(sign: .plus, exponent: Int(bits & 0x3F) - 30, significand: 1)
            let wide = (unit * 2 - 1) * exponent
            #expect(Numeric.Math.Exponential.exp(wide.truncatingRemainder(dividingBy: 700)) == Numeric.Math.Exponential.exact(wide.truncatingRemainder(dividingBy: 700)))
            #expect(Numeric.Math.Logarithm.log(wide.magnitude) == Numeric.Math.Logarithm.exact(wide.magnitude))
            #expect(Numeric.Math.Trigonometric.sin(wide) == Numeric.Math.Trigonometric.exact(wide, cosine: false))
            #expect(Numeric.Math.Trigonometric.cos(wide) == Numeric.Math.Trigonometric.exact(wide, cosine: true))
        }
    }

    @Test
    func `special values keep their meaning`() {
        #expect(Double.math.exp(0) == 1)
        #expect(Double.math.exp(-.infinity) == 0)
        #expect(Double.math.exp(.infinity) == .infinity)
        #expect(Double.math.exp(710) == .infinity)
        #expect(Double.math.exp(-746) == 0)
        #expect(Double.math.exp(-745.13) == Double.leastNonzeroMagnitude)
        #expect(Double.math.exp(.nan).isNaN)
        #expect(Double.math.log(1) == 0)
        #expect(Double.math.log(0) == -.infinity)
        #expect(Double.math.log(-0.0) == -.infinity)
        #expect(Double.math.log(-1).isNaN)
        #expect(Double.math.log(.infinity) == .infinity)
        #expect(Double.math.sin(-0.0).sign == .minus)
        #expect(Double.math.sin(0).sign == .plus)
        #expect(Double.math.cos(-0.0) == 1)
        #expect(Double.math.sin(.infinity).isNaN)
        #expect(Double.math.cos(-.infinity).isNaN)
        #expect(Double.math.sin(.nan).isNaN)
    }

    @Test
    func `Float and Float16 round the correctly rounded Double once more`() {
        for x: Float in [0.5, 1.75, -3.25, 100, 1e-3] {
            #expect(Float.math.exp(x) == Float(Double.math.exp(Double(x))))
            #expect(Float.math.sin(x) == Float(Double.math.sin(Double(x))))
            #expect(Float.math.cos(x) == Float(Double.math.cos(Double(x))))
            #expect(Float.math.log(x.magnitude) == Float(Double.math.log(Double(x.magnitude))))
        }
    }
}
