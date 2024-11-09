# compute the LRCIS 

function compute_LRCIS!(estg::ESTG) :: Set{Int}
    """
    Calculate the LRCIS for a target set `Z`, which has been used to construct the ESTG.

    Returns:
        Set{Int}: the LRCIS, i.e., a set of states
    
    Warning: this method will change the ESTG `estg` by deleting edges
    """
    Z = Set(estg.Z)  # Ensure Z is a set
    # calculate the one-step reachable set of set Z subject to disturbances
    R1Z = Set{Int}()
    ors = zeros(Int, estg.bcn.Q)
    for i in Z
        for j in 1:estg.bcn.M
            one_step_reachable_set!(ors, estg.bcn, i, j)
            union!(R1Z, ors)
        end
    end

    D0 = setdiff(R1Z, Z)
    D = Set{Int}()
    D1 = Set{Int}()  # the next set
    
    while !isempty(D0)
        for x̄ in D0
            for (i, j) in estg.PN[x̄]
                if i ∉ D
                    # delete the edge δ_N^i --> b_i^j; indicated by setting zero
                    estg.SN[i, j] = 0
                    if sum(@view estg.SN[i, :]) == 0 # all outgoing edges of δ_N^i are deleted
                        push!(D1, i)
                    end
                end
            end
        end
        union!(D, D1)
        D0, D1 = D1, D0
        empty!(D1)
    end

    return setdiff(Z, D)
end
