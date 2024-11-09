"""
Calculate the ASSR 
"""

using Revise, RSSG

f1(x, u, ξ) = u[1]
f2(x, u, ξ) = x[1]
f3(x, u, ξ) = x[1]
f4(x, u, ξ) = u[2] & (x[2] | x[5])
f5(x, u, ξ) = x[1] |ξ[1]
f6(x, u, ξ) = u[2] & (x[2] | x[5])
f7(x, u, ξ) = x[4] & (x[21] | u[3] | x[10])
f8(x, u, ξ) = (~x[9] & (x[16] & x[5] & x[11])) | (x[4] & ~x[7])
f9(x, u, ξ) = ~ x[16]  
f10(x, u, ξ) = x[18] & ξ[2]
f11(x, u, ξ) = x[21] | u[3] | x[10]
f12(x, u, ξ) = x[21] | u[3] | x[10]
f13(x, u, ξ) = x[10] & x[18] 
f14(x, u, ξ) = ~ x[12] 
f15(x, u, ξ) = x[11] 
f16(x, u, ξ) = ( x[6] & x[18] & (x[7] | u[4] | x[15] | x[19]) ) & ~ (x[20] | x[13] | x[14])
f17(x, u, ξ) = ( x[6] & x[18] & x[7] & u[4] & x[19] ) & ~ (x[20] | x[13] | x[14])
f18(x, u, ξ) = x[1]   
f19(x, u, ξ) = x[1]  
f20(x, u, ξ) = x[15] 
f21(x, u, ξ) = x[8]  

fs = [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20, f21]
m = 4
q = 2
to_file = joinpath(@__FILE__, "../data", "net.jld2")
t_par = @elapsed bcn_par = calculate_ASSR_par(fs, m, q; to_file)
t = @elapsed bcn = calculate_ASSR(fs, m, q; to_file)
@assert bcn.L == bcn_par.L
println("Time (s): $t, $t_par")