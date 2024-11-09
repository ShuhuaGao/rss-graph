# Example with the T-LGL network 
using NPZ
using Revise, RSSG

# load network data
data_dir = joinpath(@__FILE__, "..", "data")
Z = npzread(joinpath(data_dir, "Z.npy"))
println(typeof(Z))
net = npzread(joinpath(data_dir, "net.npz"))
println(typeof(net["L"]))
bcn = BCN(net["M"], net["N"], net["Q"], net["L"])

# compute the LRCIS 
println("- Calculate LRCIS...")
time_LRCIS = @elapsed begin
    Gz = ESTG(bcn, Z)
    IcZ, U1 = compute_LRCIS!(Gz, Z)
end
println("size of Z and LRCIS: ", length(Z), ", ", length(IcZ))
println("Time(s): ", time_LRCIS)


# min-time RSS
println("- Solving min-time rss...")
time_rss = @elapsed begin
    G = ESTG(bcn, 1:bcn.N)
    Fs, U2 = compute_min_time_control!(G, IcZ)
end
println("Time(s): ", time_rss)
println("Size of Ω: ", sum(length(Fk) for Fk in Fs))
println("Largest T* except ∞: ", length(Fs) - 1)
println("T* for state 1: ", get_Tstar(1, Fs))
println("T* for state 1234: ", get_Tstar(1234, Fs))
println("T* for state 7620: ", get_Tstar(7620, Fs)) 