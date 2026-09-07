# Numeric compatibility composition

Numeric is a higher-level compatibility composition, not an atom. It combines several independently meaningful numerical concepts and the platform implementation of elementary functions. Its checkout now belongs in swift-molecules, and no atom manifest or atoms workspace reference depends on it. The repository retains its existing GitHub URL during migration.

The atom owners are:

- Rounding for rounding decisions and explicit exactness failures.
- Quantizer for validated uniform grids and explicit tick storage.
- Tolerance for validated absolute and relative allowances.
- Integer for exact arbitrary-precision arithmetic, GCD/LCM, and rounded Swift integer shifts.
- Division for checked rounded quotient/remainder operations.
- Addition, Subtraction, and Multiplication for checked/saturating arithmetic; Addition and Multiplication also own augmented residual operations.
- Bit Pattern for finite bit rotation, including signed Swift storage adapters.
- Rational for exact coefficients and explicit floating-point approximation. The unconstrained Fraction wrapper has been removed.
- Trigonometry and Exponential for independent scalar capability contracts. Angle and Complex depend on those contracts directly.

Numeric retains legacy convenience accessors, optional arithmetic operators, sign/ternary wrappers, and the existing libm implementation while higher consumers are migrated in their own phase. These aggregates are not being presented as independent atoms. Complex relaxed arithmetic belongs in the existing swift-complex-numeric-relaxed integration package.

The platform backend still uses the published Numeric Shims package. Its numerical behavior, including Float16 evaluation through Float, is preserved. This backend is outside the atom dependency graph; no atom forwards through this package to obtain its implementation. Backend accuracy and supported rounding behavior follow the platform libm, without a universal correctly-rounded guarantee. A consumer importing Numeric supplies concrete scalar conformances to the atom contracts.

Migration is intentionally explicit: `Numeric.Integer.gcd/lcm` moved to Integer with arbitrary-precision results; rounded division is `Division.rounded(_:by:rounding:)`; integer right shifts come from Integer; rotation comes from Bit Pattern; native closeness uses Tolerance; and Angle fraction factories take Rational coefficients. Rounding and quantization now report invalid or inexact operations through their owning error types.
