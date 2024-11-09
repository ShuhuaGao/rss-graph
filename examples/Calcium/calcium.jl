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
Z = npzread(joinpath(data_dir, "Z.npy"))

# compute the LRCIS 
println("- Calculate LRCIS...")
time_LRCIS = @elapsed begin
    Gz = ESTG(bcn, Z)
    IcZ, U1 = compute_LRCIS!(Gz, Z)
end
println("Time(s): ", time_LRCIS)
println("size of Z and LRCIS: ", length(Z), ", ", length(IcZ))


# min-time RSS
println("- Solving min-time rss...")
time_rss = @elapsed begin
    G = ESTG(bcn, 1:bcn.N)
    Fs, U2 = compute_min_time_control!(G, IcZ)
end
println("Time(s): ", time_rss)
println("Size of Ω: ", sum(length(Fk) for Fk in Fs))
println("Largest T* except ∞: ", length(Fs) - 1)