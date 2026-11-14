extension Numeric.Math.Accessor where T: FloatingPoint {

    /// The smoothstep polynomial `s²(3 − 2s)` of a share held to 0…1: 0 at 0, 1 at 1, ½ at ½, with
    /// zero slope at both ends. Shares below 0 give 0, shares above 1 give 1, and NaN gives NaN.
    @inlinable
    public func smoothstep(_ share: T) -> T {
        guard !share.isNaN else { return share }
        let s = Swift.min(Swift.max(share, 0), 1)
        return s * s * (3 - 2 * s)
    }

    /// Smoothstep from one edge to another: the smoothstep of `(x − lower) / (upper − lower)`, so 0 at
    /// or before `lower` and 1 at or past `upper`. When `upper` is below `lower` the curve falls
    /// instead of rising. When the edges are equal it is a step: 0 below the edge and 1 at or above it.
    @inlinable
    public func smoothstep(_ x: T, from lower: T, to upper: T) -> T {
        guard upper != lower else { return x.isNaN ? x : (x < lower ? 0 : 1) }
        return smoothstep((x - lower) / (upper - lower))
    }
}
