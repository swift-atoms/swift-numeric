public import Numeric

#if !hasFeature(Embedded)
    extension Numeric.Sign: Codable {

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "positive": self = .positive
            case "negative": self = .negative
            case "zero": self = .zero
            case let value:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid Numeric.Sign value: \(value)"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .positive: try container.encode("positive")
            case .negative: try container.encode("negative")
            case .zero: try container.encode("zero")
            }
        }
    }

    extension Numeric.Ternary: Codable {}

    extension Numeric.Rounding.Direction: Codable {

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "down": self = .down
            case "up": self = .up
            case "zero": self = .zero
            case "away": self = .away
            case let value:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid Numeric.Rounding.Direction value: \(value)"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .down: try container.encode("down")
            case .up: try container.encode("up")
            case .zero: try container.encode("zero")
            case .away: try container.encode("away")
            }
        }
    }

    extension Numeric.Rounding.Nearest: Codable {

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "down": self = .down
            case "up": self = .up
            case "zero": self = .zero
            case "away": self = .away
            case "even": self = .even
            case let value:
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Invalid Numeric.Rounding.Nearest value: \(value)"
                )
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .down: try container.encode("down")
            case .up: try container.encode("up")
            case .zero: try container.encode("zero")
            case .away: try container.encode("away")
            case .even: try container.encode("even")
            }
        }
    }

    extension Numeric.Rounding: Codable {

        private enum CodingKeys: String, CodingKey {
            case direction
            case nearest
            case odd
            case exact
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            var allKeys = ArraySlice(container.allKeys)
            guard let key = allKeys.popFirst(), allKeys.isEmpty else {
                throw DecodingError.typeMismatch(
                    Numeric.Rounding.self,
                    DecodingError.Context(
                        codingPath: container.codingPath,
                        debugDescription: "Invalid number of keys found, expected one."
                    )
                )
            }
            switch key {
            case .direction:
                self = .direction(try container.decode(Direction.self, forKey: .direction))
            case .nearest:
                self = .nearest(try container.decode(Nearest.self, forKey: .nearest))
            case .odd:
                self = .odd
            case .exact:
                self = .exact
            }
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .direction(let direction):
                try container.encode(direction, forKey: .direction)
            case .nearest(let nearest):
                try container.encode(nearest, forKey: .nearest)
            case .odd:
                try container.encode(true, forKey: .odd)
            case .exact:
                try container.encode(true, forKey: .exact)
            }
        }
    }
#endif
