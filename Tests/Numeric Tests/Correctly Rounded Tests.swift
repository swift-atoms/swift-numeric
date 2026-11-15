import Testing

@testable import Numeric

@Suite
struct `Correctly Rounded Tests` {
    static let references: [(Swift.String, UInt64, UInt64)] = [
        ("exp", 0xC080709616EFF928, 0x10806978E4497E19),
        ("exp", 0x408372025AEF263E, 0x780A548A0D2C37BF),
        ("exp", 0x404EB816AD649AC0, 0x4578DFC7EEC6C70E),
        ("exp", 0x40727CEBC8182966, 0x5A9B190B6E365A4B),
        ("exp", 0xC053E82EEAE5C040, 0x38C167346DDF1D63),
        ("exp", 0x407F430C583F4D20, 0x6D08A1683E202C5F),
        ("exp", 0x40845342A95E8018, 0x7A943FA0AE1DEF2D),
        ("exp", 0x40837BE7039177A2, 0x7826ABB2BEB8EB16),
        ("exp", 0xC074F1D976CD3ABC, 0x21B71BF6CACA3149),
        ("exp", 0x4084105FE6E14DF8, 0x79D365AC361770FF),
        ("exp", 0x40570C9F4DED4C18, 0x48402393928BAD23),
        ("exp", 0x40676F25855D34D4, 0x50D61D0292E66150),
        ("exp", 0x404E7892302F0DA0, 0x456E49ADEBD56738),
        ("exp", 0xC0199ABFBE4A0580, 0x3F5B3142CC1EF43B),
        ("exp", 0x40497F229C3766D0, 0x4487B6EBEFDE5B5A),
        ("exp", 0x408253083791AD54, 0x74CF41B6582BA60F),
        ("exp", 0xC058045F3BB605A8, 0x374526E92AE1AA03),
        ("exp", 0x4075E092692B67EC, 0x5F7FE2B6CA12F17B),
        ("exp", 0xC08299A03455CF89, 0x0A43BE2C321163E2),
        ("exp", 0xC07AF03A0CF0FCD2, 0x191219D59DCC1F6B),
        ("exp", 0xC080813E3DBC5952, 0x10505E4BADCE59BD),
        ("exp", 0xC048E4475FADA510, 0x3B7218E280330E3D),
        ("exp", 0xC0509C90D6955318, 0x39F19BC225AE1E7E),
        ("exp", 0x40810F6D945C3DF2, 0x71286466F81CF2B8),
        ("exp", 0x406799C1EAF115D4, 0x50F4EFA75C5D2603),
        ("exp", 0x40801A1B81302B6E, 0x6E64A6205D343E75),
        ("exp", 0x40403A12A99E9520, 0x42DC4308D04556EF),
        ("exp", 0x40751C0AA4EA692C, 0x5E6358B2E395771C),
        ("exp", 0x406DFF3BEDC083A0, 0x559289497DF462C5),
        ("exp", 0xC08312D90F70D711, 0x08E5BE13AFA645A7),
        ("exp", 0x4076985B8638FDE4, 0x6087B1D980639C3D),
        ("exp", 0x405FE285CB1F3CB0, 0x4B70015F34F00F6B),
        ("exp", 0xC071639ABBB7C92C, 0x26D85944AC634864),
        ("exp", 0xC08484AB1B2F0055, 0x04BAE9713093CF66),
        ("exp", 0x407FFBCF634268A0, 0x6E1374773984DE9A),
        ("exp", 0xC043135D01F59C70, 0x3C7F1C5D43F00329),
        ("exp", 0xC087490A3D70A3D7, 0x0000000000000001),
        ("exp", 0xC086840000000000, 0x00000005CF08FFF0),
        ("exp", 0x40862E3D70A3D70A, 0x7FEFE9CE5C4C52B4),
        ("exp", 0x01A56E1FC2F8F359, 0x3FF0000000000000),
        ("exp", 0x3FE0000000000000, 0x3FFA61298E1E069C),
        ("log", 0x401C45C007BD89D9, 0x3FFF4A1CCD6742CE),
        ("log", 0x4017A5D11410D3F4, 0x3FFC6E7A9EA92EFB),
        ("log", 0x3FD2DC93241F7FB0, 0xBFF38C4DD22F6D0F),
        ("log", 0x3FEAFB9C5F6E8DC4, 0xBFC5D410EFC485D3),
        ("log", 0x4014D5FB3FBDCE14, 0x3FFA67F659015FE0),
        ("log", 0x4020ABC26437A95D, 0x4000F6D2FAC617F5),
        ("log", 0x401586F48814F6B6, 0x3FFAEDA7E385514F),
        ("log", 0x40146332AE9DEC02, 0x3FFA0EDB6A3E08EF),
        ("log", 0x3FE74287A13BF240, 0xBFD46A976A5486DC),
        ("log", 0x3FFCCFDF028033F6, 0x3FE2D28F5D48C1D1),
        ("log", 0x3FFB49E67A5CCF36, 0x3FE11591C6906272),
        ("log", 0x4000CF68AA6CCB4A, 0x3FE7C2EB2039D2EB),
        ("log", 0x3FE7D1D3031B215E, 0xBFD2E4FBC0FD549B),
        ("log", 0x4016943B251AD473, 0x3FFBB10EED78329F),
        ("log", 0x400A048B11EC1AFA, 0x3FF2DE90D52A0436),
        ("log", 0x4018257B6B383EEC, 0x3FFCC3F57D4E2D36),
        ("log", 0x3FDAB66B9AB89224, 0xBFEBF5BF649BF53B),
        ("log", 0x400ACC86F39C7587, 0x3FF357BD1A2BF945),
        ("log", 0x40227C3E1C5662F6, 0x4001CA6750BB771D),
        ("log", 0x3FE97BB7D84C7F1E, 0xBFCD25B80554F6AC),
        ("log", 0x40228E36940D740A, 0x4001D22A83FB1F2D),
        ("log", 0x3FC2D806374DA2D8, 0xBFFEA74BF8BBE9DB),
        ("log", 0x4010728A1047BF8F, 0x3FF69F3A91B100EF),
        ("log", 0x3FF7800247F49ABC, 0x3FD89A39BD19C0B3),
        ("log", 0x65188BAFAD2B8ED5, 0x4079C284979D543E),
        ("log", 0x52F959186876FB5C, 0x406A65A8CC179314),
        ("log", 0x041AE96619D4DAAA, 0xC084BC1EC5F84FBD),
        ("log", 0x268DB3D1148F32F6, 0xC07197E04F397B62),
        ("log", 0x504B2D87D5B8A57C, 0x4066AE1E89DF1D63),
        ("log", 0x176F6F22F5156258, 0xC07C12D5DF22707B),
        ("log", 0x32CB6BCB654F9F2A, 0xC06236E4000488D2),
        ("log", 0x411A20AB57A9C884, 0x4029EF219C7DD8DD),
        ("log", 0x0CF48F2F8E3FB5EC, 0xC081AADBE6C11920),
        ("log", 0x7887B6471FB537F3, 0x40839D886154AAFD),
        ("log", 0x0DC16A91F2B02B48, 0xC081641954CBAC86),
        ("log", 0x235691406BCB5030, 0xC073D1E13EC6ADC4),
        ("log", 0x0000000000000001, 0xC0874385446D71C3),
        ("log", 0x000012688B70E62B, 0xC0864E69394D9508),
        ("log", 0x7FEFFFFFFFFFFFFF, 0x40862E42FEFA39EF),
        ("log", 0x3FF0000000000001, 0x3CAFFFFFFFFFFFFF),
        ("log", 0x3FEFFFFFFFFFFFFF, 0xBCA0000000000000),
        ("sin", 0xC0467FBBA73BC1CF, 0xBFEB319C4A0C5623),
        ("sin", 0x40440ED374EF2B80, 0x3FE537A5B5EB2549),
        ("sin", 0x4057C1C4D673A45C, 0x3FE680723978C0A3),
        ("sin", 0x40548933AAD6188C, 0x3FDC8C69879812AB),
        ("sin", 0x4051D6ECB663F99C, 0x3FE9090725FE0BDA),
        ("sin", 0xC054373E824B7A32, 0x3FE75B95089BF2DA),
        ("sin", 0x4051E499F04BF2DE, 0x3FE43D2DA249A111),
        ("sin", 0x4054267CEFAD0DC0, 0xBFEC3920AE71F3A2),
        ("sin", 0xC051645885477D6F, 0xBFDC00B4A4AE6E7D),
        ("sin", 0x402D03CE6A41CF80, 0x3FEDD4D5692E5F4D),
        ("sin", 0xC0352918C7970078, 0xBFE7A087458830DF),
        ("sin", 0xC0035A87485453E0, 0xBFE528610A71AB1F),
        ("sin", 0xC04BD99B896432AE, 0x3FE802F5F309644C),
        ("sin", 0xC04C8FF982D14B32, 0xBFE16EE3976D7187),
        ("sin", 0xC0529851D3EB9968, 0x3FEB3CDDC65747FD),
        ("sin", 0xC0510F33D97F1556, 0x3FE89CD153631519),
        ("sin", 0x40499BFBDF8E6E20, 0x3FEA166FE6F92752),
        ("sin", 0x4050453D833E1C36, 0x3FE8E5D707A88A8A),
        ("sin", 0xC046183D17E5BB4C, 0xBFCA50CBDAE3BA00),
        ("sin", 0xC04730868EAE516D, 0xBFE5B0A40EA159EF),
        ("sin", 0xC055F55CABC231EC, 0x3FC0B244FFBC2ABD),
        ("sin", 0xC039F2025112CAB4, 0xBFE73C1043083818),
        ("sin", 0x40509826FB3C6C5A, 0xBFD9278A35B09082),
        ("sin", 0x40549B450A3275AC, 0x3FE5B0045894A092),
        ("sin", 0xC12C51CCA5C70CFA, 0x3FEE79FF718B7209),
        ("sin", 0xC12E137D10BF8AA7, 0x3FEDEE96D537F7A6),
        ("sin", 0xC127EB22C6B0B69A, 0xBF76C3EA8DDF00D3),
        ("sin", 0x40F15F4569C74700, 0xBFE577252F6883A9),
        ("sin", 0x412B65FDF8F7246C, 0xBFE6DD32D5EA508B),
        ("sin", 0x412CC612A1EC2010, 0x3FE265ED041E7BFB),
        ("sin", 0xC119701CCF751CE2, 0x3FEBAE49624DAE27),
        ("sin", 0xC11CE2965CB19906, 0x3FE9AEA8769CF6FC),
        ("sin", 0x4480F0CF064DD592, 0xBFEB453AB76BF397),
        ("sin", 0x7506AC5B262CA1FF, 0x3FF0000000000000),
        ("sin", 0xFE37E43C8800759C, 0x3FEA2C16B010E385),
        ("sin", 0x3FF921FB54442D18, 0x3FF0000000000000),
        ("sin", 0x400921FB54442D18, 0x3CA1A62633145C07),
        ("sin", 0x8000000000000001, 0x8000000000000001),
        ("sin", 0x41CDCD6500000000, 0x3FE1778CAE83C69B),
        ("cos", 0xC051911F4845A20D, 0x3FD9FF4FB16AC511),
        ("cos", 0xC051614BD555EE90, 0x3FED6897A0B05998),
        ("cos", 0xC0575264F897CB10, 0x3FE257D05081C695),
        ("cos", 0xC04247FACFDFE51D, 0x3FDAE9EA4E52CDB3),
        ("cos", 0xC00151A045251920, 0xBFE1E94F3DB4FA19),
        ("cos", 0x4054DA0D74721AEA, 0xBFC3BE62B2184DFD),
        ("cos", 0x404B241A850B7B60, 0xBFE4832543F9170B),
        ("cos", 0x404263F66F5C5260, 0x3FE36EE7429E3D56),
        ("cos", 0xC0543A37D4DB9056, 0x3FE6EF20BF946CDB),
        ("cos", 0xC0161C68A410F1C0, 0x3FE74B84332D03CC),
        ("cos", 0xC058EEEAAAF70FBC, 0x3FE657CC03D6FBE9),
        ("cos", 0xC02355160698A880, 0xBFEF12749F01ECDF),
        ("cos", 0xC04F591426A4E7A0, 0x3FEFB4708EDF5637),
        ("cos", 0xC051938D6CAD7B2E, 0x3FD7C22616504096),
        ("cos", 0x40574BDEB5606986, 0x3FDF289ED6554A48),
        ("cos", 0x40468CCE831638A4, 0x3FDC034F2F16EDC1),
        ("cos", 0xC0517C35BCAB008E, 0x3FE5B2468234AFEE),
        ("cos", 0x404EE7942BCE0E80, 0x3FE0ACF1BE2F1063),
        ("cos", 0x4053C2F9125FD288, 0xBFEBFAEFBCED7954),
        ("cos", 0xC05175CE15898C88, 0x3FE7F017E715D5C9),
        ("cos", 0x404FE6FA0B55DB40, 0x3FE204FDFCCABBFF),
        ("cos", 0xC055C0D113077282, 0x3FE290EC432BBBDA),
        ("cos", 0x4051F30D25EFDB60, 0xBFECB0438C8D81F0),
        ("cos", 0x402581CAFC1401A0, 0xBFCEAEFD0CA787DF),
        ("cos", 0xC12AD9BDF51E0195, 0xBFC5EF167537C771),
        ("cos", 0x410F16D1BE8245B0, 0x3FED47E88AB7DBE2),
        ("cos", 0xC0F07AB23FECB098, 0x3FDBEEC6D4FB5737),
        ("cos", 0x4115E28B2F2E9A98, 0x3FEEEC5906E94CD2),
        ("cos", 0xC111FEF822BB6018, 0x3FD256826D110E96),
        ("cos", 0x41194331FEB38C68, 0xBFD7AE198E21D9BD),
        ("cos", 0x411D0E9250635EDC, 0xBFDFB3D656066BA5),
        ("cos", 0xC12D29E61FC0DF86, 0x3FEECA29E4C5E668),
        ("cos", 0x4480F0CF064DD592, 0x3FE0BE2CEF01C8F4),
        ("cos", 0x7506AC5B262CA1FF, 0xBC214AE72E6BA22F),
        ("cos", 0xFE37E43C8800759C, 0xBFE2699022ADC4C1),
        ("cos", 0x3FF921FB54442D18, 0x3C91A62633145C07),
        ("cos", 0x400921FB54442D18, 0xBFF0000000000000),
        ("cos", 0x8000000000000001, 0x3FF0000000000000),
        ("cos", 0x41CDCD6500000000, 0x3FEACFF8C7364234),
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
