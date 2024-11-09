"""Build ESTG
- NV: normal vertex 
- BV: branching vertex
"""

struct NormalVertex
    i::Int64    # δ_N^i
end

struct BranchingVertex
    i::Int64    # δ_N^i
    j::Int16    # δ_M^j
end

"""
    ESTG 

Expanded STG. 
Note that the current integer types allow at most 62 state variables and 14 control variables to save space.
"""
struct ESTG
    bcn::BCN
    # SB[i, j, ξ] stores the successor (a NV) of BV b_i^j driven by disturbance ξ
    SB::Array{Int64, 3}
    # SN[i, j] stores the successors of NV δ_N^i; only j is recorded (each a branching vertex)
    SN::BitMatrix
    # PN[i] stores the predecessors of normal vertex δ_N^i (each a branching vertex as a tuple)
    PN::Dict{Int64, Set{Tuple{Int64, Int16}}}
    # the unique predecessor of a BV b_i^j is always δ_N^i; no need to store it explicitly  
    # in SB SN, a value 0 indicates the deletion of a vertex or edge 
end



function ESTG(bcn::BCN, Z::Union{AbstractVector{<:Integer}, AbstractSet{<:Integer}})
    M, N, Q = bcn.M, bcn.N, bcn.Q
    # preallocate memory; because we use vectors, always allocate a complete graph
    SB = zeros(Int64, N, M, Q)
    SN = BitMatrix(undef, N, M)
    # PN = [Set{Tuple{Int64, Int16}}() for _ in 1:N]
    PN = Dict{Int64, Set{Tuple{Int64, Int16}}}()

    for i in Z
        for j in 1:M    # enumerate every control input 
            SN[i, j] = 1
            for ξ in 1:Q
                k = evolve(bcn, i, j, ξ)
                SB[i, j, ξ] = k
                # one predecessor of δ_N^k is branching (i, j)
                if haskey(PN, k)
                    push!(PN[k], (i, j))
                else
                    PN[k] = Set{Tuple{Int64, Int16}}([(i, j)])
                end
                # push!(PN[k], (i, j))
            end
        end
    end
    return ESTG(bcn, SB, SN, PN)
end