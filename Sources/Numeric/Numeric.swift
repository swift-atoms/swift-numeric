public import Quantizer
public import Rounding

public enum Numeric {

    public typealias `Protocol` = Swift::Numeric
}

extension Numeric {
    public typealias Transcendental = Numeric::Transcendental
}

extension Numeric {

    public typealias Integer = Int
}

extension Numeric { public typealias Quantized = Quantizer::Quantized }

extension Numeric { public typealias Rounding = Rounding::Rounding }
