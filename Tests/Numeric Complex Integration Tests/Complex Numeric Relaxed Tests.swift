#if Complex
import Complex
import Numeric
import Testing

@Suite
struct `Complex Numeric Relaxed Tests` {}

extension `Complex Numeric Relaxed Tests` {

    @Test
    func `double operations use relaxed scalar arithmetic`() {
        let a = Complex.Number<Double>(2, 3)
        let b = Complex.Number<Double>(4, -5)
        let c = Complex.Number<Double>(1, 1)

        let sum = Numeric.Relaxed.sum(a, b)
        #expect(sum.realValue == 6)
        #expect(sum.imaginaryValue == -2)

        let product = Numeric.Relaxed.product(a, b)
        #expect(product.realValue == 23)
        #expect(product.imaginaryValue == 2)

        let multiplyAdd = Numeric.Relaxed.multiplyAdd(a, b, c)
        #expect(multiplyAdd.realValue == 24)
        #expect(multiplyAdd.imaginaryValue == 3)

        let rightScaled = Numeric.Relaxed.product(a, Double(2))
        #expect(rightScaled.realValue == 4)
        #expect(rightScaled.imaginaryValue == 6)

        let leftScaled = Numeric.Relaxed.product(Double(2), a)
        #expect(leftScaled.realValue == 4)
        #expect(leftScaled.imaginaryValue == 6)
    }

    @Test
    func `float operations use relaxed scalar arithmetic`() {
        let a = Complex.Number<Float>(1.5, -2)
        let b = Complex.Number<Float>(-3, 4)
        let c = Complex.Number<Float>(0.5, -1)

        let sum = Numeric.Relaxed.sum(a, b)
        #expect(sum.realValue == -1.5)
        #expect(sum.imaginaryValue == 2)

        let product = Numeric.Relaxed.product(a, b)
        #expect(product.realValue == 3.5)
        #expect(product.imaginaryValue == 12)

        let multiplyAdd = Numeric.Relaxed.multiplyAdd(a, b, c)
        #expect(multiplyAdd.realValue == 4)
        #expect(multiplyAdd.imaginaryValue == 11)

        let rightScaled = Numeric.Relaxed.product(a, Float(-2))
        #expect(rightScaled.realValue == -3)
        #expect(rightScaled.imaginaryValue == 4)

        let leftScaled = Numeric.Relaxed.product(Float(-2), a)
        #expect(leftScaled.realValue == -3)
        #expect(leftScaled.imaginaryValue == 4)
    }
}

#endif
