# Numeric

Numeric is being decomposed into concept-owned atoms. It is not the owner of every operation on numbers. During migration, compatibility accessors delegate to their established owners.

- Addition, Subtraction, and Multiplication own saturating fixed-width arithmetic.
- Addition and Multiplication own augmented operations and their residual-error contracts.
- Integer owns exact GCD and LCM; migrate `Numeric.Integer.gcd/lcm` to `Integer.gcd/lcm`. Results are arbitrary-precision Integers, with explicit fixed-width conversion.
- Relaxed arithmetic uses ordinary Swift evaluation. Multiply-add evaluates a product then a sum; callers must not depend on contraction or reassociation.

Rounding is now owned by swift-rounding. Floating-point `rounding(_:)` throws on nonfinite or inexact inputs. Swift integer `shifted.right` is imported from Integer and throws on inexact shifts. Rounded fixed-width division is `Division.rounded(_:by:rounding:)`, with explicit errors and a returned quotient/remainder pair. The previous Numeric division accessor has been removed.

Quantizer and Tolerance now provide independent validated grid and deviation contracts. Their consumer migrations and elementary functions are the next semantic boundaries to separate. The remaining libm shim dependency is not an accepted atom boundary.

Bit rotation has moved to Bit Pattern's `rotatedLeft(by:)` and `rotatedRight(by:)` Swift adapters. Native floating-point closeness is expressed with Tolerance rather than Numeric.Comparison. Quantized is temporarily an alias of Quantizer.Quantized; its quantize operation now throws explicit failures.
