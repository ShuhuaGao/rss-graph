"""Minimum time robust set stabilization
"""

"""
    delete_BN_edge!(estg::ESTG, i, j, k)

Delete BN edge b_i^j --> δ_N^k
"""
function delete_BN_edge!(estg::ESTG, i, j, k)
    # clear the recodes in both the successor and predecessor
    # setting zero indicates deletion
    for ξ in 1:estg.bcn.Q
        if estg.SB[i, j, ξ] == k
            estg.SB[i, j, ξ] = 0
        end
    end
    PNk = estg.PN[k]
    np = length(PNk)
    for idx in 1:np
        if PNk[idx] == (i, j)
            PNk[idx] = (0, 0)
        end
    end 
end

function compute_min_time_control!(estg::ESTG, IcZ::Union{AbstractVector, AbstractSet})
    Q = estg.bcn.Q
    F0 = Set(IcZ)
    F = copy(F0)
    Fs = [copy(F0)] # stores F0, F1, ...
    U = Dict{UInt64, Vector{UInt16}}()
    F1 = Set{UInt64}()
    # F0 is Fk, and F1 is F_{k+1}
    while !isempty(F0)
        empty!(F1)
        for k in F0
            for (i, j) in estg.PN[k]
                if i > 0  # the BN edge b_i^j --> k still exits 
                    if i ∉ F
                        delete_BN_edge!(estg, i, j, k)
                        if sum(@view estg.SB[i, j, :]) == 0  # all successors of b_i^j have been deleted
                            push!(F1, i)
                            # append control j to state i's feasible control set
                            if haskey(U, i)
                                push!(U[i], j)
                            else
                                U[i] = [j]
                            end
                        end
                    end
                end
            end
        end
        # get a new set F1 expanding the boundary of stabilization domain 
        union!(F, F1)
        if !isempty(F1)
            push!(Fs, copy(F1))
        end
        F0, F1 = F1, F0
    end
    return Fs, U
end


function get_Tstar(i::Integer, Fs::AbstractVector{Set})::Int
    """After obtaining `Fs` with `compute_min_time_control`, retrieve the minimum stabilization time 
    of a state `i`.

    Returns:
        Int: T*. -1 is returned if the state `i` cannot be stabilized.
    """
    for (T, F) in enumerate(Fs)
        if i in F
            return T - 1
        end
    end
    return -1
end