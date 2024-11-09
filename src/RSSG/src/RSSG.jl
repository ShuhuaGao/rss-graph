module RSSG

using Base.Iterators: product, repeated
using JLD2

include("logical.jl")
const LM = LogicalMatrix
const LV = LogicalVector

include("boolean_network.jl")
include("estg.jl")
include("lrcis.jl")
include("min_time.jl")

export compute_min_time_control!, get_Tstar, compute_LRCIS!, ESTG

end # module RSSG
