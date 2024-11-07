"""Build ESTG
"""

struct NormalVertex
    i::Int64    # δ_N^i
end

struct BranchingVertex
    i::Int64    # δ_N^i
    j::Int16    # δ_M^j
end

struct ESTG{TPN}
    bcn::BCN
    Z::Vector{Int64}
    PN::TPN      # predecessors of a normal vertex 
    # if we build a complete ESTG, then TPN will be Vector{Vector{Int64}}; otherwise, Dict{Int64, Vector{Int64}}
end


function successors!(ss::AbstractVector{BranchingVertex},estg::ESTG, v::NormalVertex)::AbstractVector{BranchingVertex}
    for j in 1:estg.bcn.M 
        ss[j] = BranchingVertex(v.i, j)
    end
    return @view ss[1:estg.bcn.M]
end

function successors!(ss::AbstractVector{NormalVertex},estg::ESTG, v::BranchingVertex)::AbstractVector{NormalVertex}
    i, j = v.i, v.j
    bcn = estg.bcn
    for ξ in 1:bcn.Q
        k = evolve(bcn, i, j, ξ)
        ss[ξ] = NormalVertex(k)
    end
    return @view ss[1:bcn.Q]
end

"""
    predecessor(v::NormalVertex)::BranchingVertex

Get the unique predecessor of a normal vertex `v`.
"""
function predecessor(v::BranchingVertex)::NormalVertex
    i = v.i
    return NormalVertex(i)
end

"""
    predecessors(v::NormalVertex, estg::ESTG)::Vector{BranchingVertex}

Get the predecessors of a normal vertex `v`.
"""
function predecessors(v::NormalVertex, estg::ESTG)::Vector{BranchingVertex}
    i = v.i
    return estg.PN[i]
end


function ESTG(bcn::BCN, Z::AbstractVector{<:Integer})
    M, N, Q = bcn.M, bcn.N, bcn.Q
    if N == length(Z)   # complete ESTG graph; better use an array 
        PN = Vector{Vector{BranchingVertex}}()
        for _ in 1:N
            push!(PN, Vector{BranchingVertex}())
        end
    else    # incomplete ESTG graph; better use a dictionary
        PN = Dict{Int64, Vector{BranchingVertex}}()
    end

    for i in Z
        for j in 1:M    # enumerate every control input 
            # mainly to get the predecessors of a normal vertex
            for ξ in 1:Q
                k = evolve(bcn, i, j, ξ)
                # one predecessor of δ_N^k is branching (i, j)
                if PN isa Vector
                    push!(PN[k], BranchingVertex(i, j))
                else
                    if haskey(PN, k)
                        push!(PN[k], BranchingVertex(i, j))
                    else
                        PN[k] = [BranchingVertex(i, j)]
                    end
                end
            end
        end
    end
    
end
