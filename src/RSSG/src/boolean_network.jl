# represent a BCN under disturbances
using JLD2


struct BCN
    M::Int64
    N::Int64
    Q::Int64
    L::Vector{Int64}

    function BCN(M::Integer, N::Integer, Q::Integer, L::AbstractVector{<:Integer})
        @assert length(L) == M * N * Q
        @assert all(e -> 1 <= e <= N, L)
        return new(M, N, Q, convert(Vector{Int64}, L))
    end
end


function evolve(bcn::BCN, x::Integer, u::Integer, ξ::Integer)
    (; M, N) = bcn
    k = x
    j = u
    i = ξ
    blk_i = @view bcn.L[(i-1)*M*N+1:i*M*N]
    blk_j = @view blk_i[(j-1)*N+1:j*N]
    return blk_j[k]  # an integer
end

function one_step_reachable_set!(rs::AbstractVector{<:Integer}, bcn::BCN, x::Integer, u::Integer)
    for ξ in 1:bcn.Q
        rs[ξ] = evolve(bcn, x, u, ξ)
    end
    return @view rs[1:bcn.Q]
end

function evolve(bcn::BCN, x::LogicalVector, u::LogicalVector, ξ::LogicalVector)
    n = evolve(bcn, index(x), index(u), index(ξ))
    return LogicalVector(n, bcn.N)
end


"""
    calculate_ASSR(fs, m, q; to_file::String="") -> BCN

Given a list of Boolean functions `fs`, number of controls `m`, and number of disturbances `q`, 
build the algebraic form of the BCN.
If `to_file` is specified, then the BCN model is written into that file using `JLD2`.
"""
function calculate_ASSR(fs::AbstractVector{<:Function}, m, q; to_file::String="")::BCN
    n = length(fs)
    Q = 2^q
    M = 2^m
    N = 2^n
    idx = Vector{Int64}(undef, Q * M * N) # index vector in L
    for xb in product(repeated([true, false], n)...)
        for ub in product(repeated([true, false], m)...)
            for ξb in product(repeated([true, false], q)...)
                # turn each boolean tuple into a logical vector, and multiply the RHS
                x = LogicalVector(collect(xb))
                u = LogicalVector(collect(ub))
                ξ = LogicalVector(collect(ξb))
                s = ξ * u * x
                # calculate the LHS with raw Boolean operators
                xb′ = BitVector()
                for fi in fs
                    push!(xb′, fi(xb, ub, ξb))
                end
                x′ = LogicalVector(xb′)
                # set the logical matrix
                idx[index(s)] = index(x′)
            end
        end
    end

    bcn = BCN(M, N, Q, idx)
    if !isempty(to_file)
        jldsave(to_file; bcn)
    end
    return bcn
end