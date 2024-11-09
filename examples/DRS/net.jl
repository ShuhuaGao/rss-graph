"""
Calculate the ASSR 
"""

using Revise, RSSG

f1(x, u, ξ) = x[22] & ~ x[7]
f2(x, u, ξ) = u[2] & u[3]
f3(x, u, ξ) = x[11] | x[13]
f4(x, u, ξ) = (x[1] & ~ x[8]) | (x[4] & ~ x[8])
f5(x, u, ξ) = x[19] | ξ[1]
f6(x, u, ξ) = x[24] & u[3]
f7(x, u, ξ) = x[14] & ~ x[20]
f8(x, u, ξ) = x[3]
f9(x, u, ξ) = x[1]
f10(x, u, ξ) = x[1] & ξ[2]
f11(x, u, ξ) = x[18] & ~ x[10]
f12(x, u, ξ) = ~ x[11]
f13(x, u, ξ) = x[17] & ~x[10] 
f14(x, u, ξ) = (x[16] & x[12]) & ~ x[20] 
f15(x, u, ξ) = (~ x[12] ) | ~ x[12]
f16(x, u, ξ) = x[3]
f17(x, u, ξ) = ( x[6] & ~ x[9] ) | ( x[2] & ~ x[9] )  | ( x[7] & ~ x[9] )     
f18(x, u, ξ) = ( x[5] & ~ x[1] )  | ( x[11] & ~ x[1] )    
f19(x, u, ξ) = ( x[2]  & ~ x[17] )  | ( x[24] & ~ x[17]  ) 
f20(x, u, ξ) = ( x[1]  & ~ x[8] ) 
f21(x, u, ξ) = x[7]
f22(x, u, ξ) = x[23]
f23(x, u, ξ) = x[4] & x[19]
f24(x, u, ξ) = u[1]
f25(x, u, ξ) = x[1]  

fs = [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20, f21, f22, f23, f24, f25]
m = 3
q = 2
to_file = joinpath(@__FILE__, "../data", "net.jld2")
t_par = @elapsed bcn_par = calculate_ASSR_par(fs, m, q; to_file)
println("Time (s): $t_par")