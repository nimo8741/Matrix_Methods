function [N] = NURBS_2D(xi_1,xi_2,i_1,i_2,p_1,p_2,n_1,n_2,Xi_1,Xi_2,w_1,w_2)
%% Do first dimension first
if sum(w_1 - 1) ~= 0
    w_tot = 0;
    for j = 1:n_1
        N_cur(j) = getN(xi_1,j,p_1,Xi_1);
        w_tot = w_tot + w_1(j)*N_cur(j);
    end
    R = (w_1.*N_cur)/w_tot;
    R_1 = R(i_1);
    
else
    R_1 = getN(xi_1,i_1,p_1,Xi_1);
end
if isnan(R_1)
    R_1 = 0;
end
%% Do the second dimension
if sum(w_2 - 1) ~= 0
    w_tot = 0;
    for j = 1:n_2
        N_cur2(j) = getN(xi_2,j,p_2,Xi_2);
        w_tot = w_tot + w_2(j)*N_cur2(j);
    end
    R = (w_2.*N_cur2)/w_tot;
    R_2 = R(i_2);
else
    R_2 = getN(xi_2,i_2,p_2,Xi_2);
end
if isnan(R_2)
    R_2 = 0;
end

N = R_1*R_2;

end