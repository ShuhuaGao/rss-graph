# Examples of the tiny network detailed in the paper as Example xx
using Revise, RSSG

# network definition with three Boolean functions 
f1(x::TVB, u::TVB, ξ::TVB) = x[2] | x[3]
f2(x::TVB, u::TVB, ξ::TVB) = x[1] & u[1]
f3(x::TVB, u::TVB, ξ::TVB) = u[1] | (ξ[1] & x[1])

# build ASSR
println("- build ASSR")
bcn = calculate_ASSR([f1, f2, f3], 1, 1)
println("L is: ")
display(bcn.L')

bcn = calculate_ASSR_par([f1, f2, f3], 1, 1)
@show Threads.nthreads()
println("L is: ")
display(bcn.L')


Z = Set([2, 4, 5, 7])
println("- Example 1: ESTG")
Gz = ESTG(bcn, Z)
println("Gz.SN:")
display(Gz.SN)
println("Gz.SB:")
display(Gz.SB)
println("Gz.PN:")
display(Gz.PN)


println("- Example 2: LRCIS")
IcZ, U1 = compute_LRCIS!(Gz, Z)
println("IcZ:")
display(IcZ)
println("U1:")
display(U1)

println("- Example 3: min-time RSS")
# construct an ESTG for all states in ΔN
G = ESTG(bcn, 1:bcn.N)
display(G.PN)
Fs, U2 = compute_min_time_control!(G, IcZ)
println("Fs:")
display(Fs)
println("U2:")  
display(U2)