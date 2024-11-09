module RSSG

using Base.Iterators: product, repeated
using JLD2

include("logical.jl")
const LM = LogicalMatrix
const LV = LogicalVector
const TVB = Tuple{Vararg{Bool}}

include("boolean_network.jl")
include("estg.jl")
include("lrcis.jl")
include("min_time.jl")

export compute_min_time_control!, get_Tstar, compute_LRCIS!, ESTG, LM, LV, TVB, BCN, calculate_ASSR,
calculate_ASSR_par

end # module RSSG
