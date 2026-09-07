# Numeric

Numeric is being decomposed into concept-owned atoms. It is not the owner of every operation on numbers. During migration, compatibility accessors delegate to their established owners.

- Addition, Subtraction, and Multiplication own saturating fixed-width arithmetic.
- Addition and Multiplication own augmented operations and their residual-error contracts.
- Integer owns exact GCD and LCM; migrate `Numeric.Integer.gcd/lcm` to `Integer.gcd/lcm`. Results are arbitrary-precision Integers, with explicit fixed-width conversion.
- Relaxed arithmetic uses ordinary Swift evaluation. Multiply-add evaluates a product then a sum; callers must not depend on contraction or reassociation.

Rounding, quantization, tolerance, and elementary functions are the next semantic boundaries to separate. The remaining libm shim dependency is not an accepted atom boundary.
