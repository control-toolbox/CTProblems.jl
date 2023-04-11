import Base.∈

struct Interval
    a::Real
    b::Real
end

∈(x::Real, I::Interval) = I.a ≤ x ≤ I.b

struct IntervalUnion
    intervals::Vector{Interval}
end

∈(x::Real, I::IntervalUnion) = any(x ∈ Ii for Ii in I.intervals)

@assert 0.5 ∈ Interval(0, 1)

@assert 0.5 ∈ IntervalUnion([Interval(0, 0.5), Interval(0.6, 1)])

∪(I1::Interval, I2::Interval) = IntervalUnion([I1, I2])
∪(I1::Interval, I2::IntervalUnion) = IntervalUnion([I1, I2.intervals...])
∪(I1::IntervalUnion, I2::Interval) = IntervalUnion([I1.intervals..., I2])
∪(I1::IntervalUnion, I2::IntervalUnion) = IntervalUnion([I1.intervals..., I2.intervals...])