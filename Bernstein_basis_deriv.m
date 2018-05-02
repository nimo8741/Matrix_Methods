function [Ba,dB_dXi1,dB_dXi2] = Bernstein_basis_deriv(xi_1,p,i_1,Xi_1,xi_2,i_2,Xi_2)
%% Inputs:
% xi_1: value at which to evaluate the basis function which lies in the
% first direction
% p: polynomial degree (assumed the same for each direction)
% i_1: the indentifier (number) of the basis function of which to be evaluated (first
% direction
% Xi_1: knot vector for the parent element in the first direction
%
% xi_2: same as for xi_1
% i_1: same as for i_1
% Xi_2: same as for Xi_2

%% Get values of each basis function
Ba1 = getN(xi_1,i_1,p,Xi_1);
Ba2 = getN(xi_2,i_2,p,Xi_2);  % these are the values of the bernstein polynomials


%% Compute the derivative for the first direction
dB_dXi1 = nchoosek(p,i_1-1)*(i_1-1)*xi_1^(i_1-2)*(1-xi_1)^(p+1-i_1) + nchoosek(p,i_1-1)*xi_1^(i_1-1)*(i_1 - p - 1)*(1-xi_1)^(p-i_1);
dB_dXi1 = dB_dXi1*Ba2;
if isnan(dB_dXi1) || isinf(dB_dXi1)
    dB_dXi1 = 0;
end

%% Compute the derivative for the second direction
dB_dXi2 = nchoosek(p,i_2-1)*(i_2-1)*xi_2^(i_2-2)*(1-xi_2)^(p+1-i_2) + nchoosek(p,i_2-1)*xi_2^(i_2-1)*(i_2 - p - 1)*(1-xi_2)^(p-i_2);
dB_dXi2 = dB_dXi2*Ba1;
if isnan(dB_dXi2) || isinf(dB_dXi2)
    dB_dXi2 = 0;
end

%% Compute the value of the two dimensional basis function
Ba = Ba1*Ba2;



end