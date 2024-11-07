module RSSG

using Base.Iterators: product, repeated
using JLD2

include("logical.jl")
const LM = LogicalMatrix
const LV = LogicalVector

include("boolean_network.jl")
include("estg.jl")
include("lrcis.jl")

end # module RSSG
