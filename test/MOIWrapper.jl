using MathOptInterface
const MOI = MathOptInterface
const MOIT = MOI.Test
const MOIB = MOI.Bridges

const MOIU = MOI.Utilities
MOIU.@model ECOSModelData () (EqualTo, GreaterThan, LessThan) (Zeros, Nonnegatives, Nonpositives, SecondOrderCone, ExponentialCone) () (SingleVariable,) (ScalarAffineFunction,) (VectorOfVariables,) (VectorAffineFunction,)
const optimizer = MOIU.CachingOptimizer(ECOSModelData{Float64}(), ECOS.Optimizer(verbose=false))

# SOC2 requires 1e-4
const config = MOIT.TestConfig(atol=1e-4, rtol=1e-4)

@testset "Continuous linear problems" begin
    MOIT.contlineartest(MOIB.SplitInterval{Float64}(optimizer), config)
end

@testset "Continuous conic problems" begin
    MOIT.contconictest(MOIB.GeoMean{Float64}(MOIB.RSOC{Float64}(optimizer)),
                       config, ["sdp", "rootdet", "logdet"])
end
