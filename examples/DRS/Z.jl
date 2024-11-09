"""
Find a proper Z for numerical studies.
"""

using JLD2, FileIO, NPZ
using Revise, RSSG

# load network data
data_dir = joinpath(@__FILE__, "..", "data")
assr_file = joinpath(data_dir, "net.jld2")
#! if the ASSR has not been calculated, execute "net.jl" first
if !isfile(assr_file)
    println("- First compute the ASSR...")
    include(joinpath(@__FILE__, "..", "net.jl"))
end
bcn = load(assr_file, "bcn")
N = bcn.N 

# find a proper Z
while true
    # get a random set Z 
    Z = rand(1:N, 50000)
    # compute the LRCIS
    Gz = ESTG(bcn, Z)
    IcZ, U1 = compute_LRCIS!(Gz, Z)
    @show length(IcZ)
    if length(IcZ) >= 20
        break 
    end
end

# combine more states with IcZ to form the final Z 
# then we know that the LRCIS of this Z cannot be empty.
Z = union(IcZ, rand(1:N, 5000))

# save Z
npzwrite(joinpath(@__FILE__, "..", "data", "Z.npy"), Z)


