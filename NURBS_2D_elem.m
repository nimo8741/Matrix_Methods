function [N] = NURBS_2D_elem(xi_1,xi_2,i_1,i_2,p_1,p_2,n_1,n_2,Xi_1,Xi_2,w)
% Inputs:
% xi_1: xi_1 evaluation point value
% xi_2: xi_2 evaluation point value]
% i_1: index of Xi_1 knot vector's basis function to be evaluated
% i_2: same but for Xi_2
% p_1: polynomial degree for Xi_1
% p_2: same but for Xi_2
% n_1: number of basis functions in Xi_1
% n_2: same but for Xi_2
% Xi_1: knot vector in direction 1
% Xi_2: knot vector in direction 2
% w = weight matrix

% Outputs:
% N: basis function evaluated at the desired parameters
%% Do the tensor product of both dimensions
w_tot = 0;
for j = 1:n_1
    for k = 1:n_2
        N_cur(j,k) = getN(xi_1,j,p_1,Xi_1)*getN(xi_2,k,p_2,Xi_2);
        w_tot = w_tot + w(j,k)*N_cur(j,k);
    end
end
R = (w.*N_cur)./w_tot;
N = R(i_1,i_2);


if isnan(N)
    N = 0;
end

end