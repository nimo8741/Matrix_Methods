function [Ra,dRa_dx,dRa_dy,x,J] = Shape_function(e,xi_1,xi_2,n_loc,p,Xi_1,Xi_2,w_be,w_ae,C,P,IEN)
%% Inputs
% e: element number
% xi_1: value in parent element first direction at which to evaluate
% xi_2: same as xi_1 but in the second direction
% n_loc: number of basis functions in element, for refined P = 2, 2
% dimensions, there are 9
% p: polynomial degree
% Xi_1: parent knot vector, first direction
% Xi_2: same as for Xi_1
% w_be: element wise bezier weights
% w_ae: pre-extraction weights

%% Nomenclature (finish this part up later)
% Ra = value of the bernstein polynomial which has been modiied by the
% weights
%
% x = physical location
% J = Jacobian
% w_b = scalar total weight
% w_ae = Original pre-extraction weighting array
% w_be = post-extraction bezier element weighting array]
% w_ae_trans = transpose of w_ae.  The reason this is done is so that the
% correct element in the matrix can be referenced by simply using the IEN
% array.  Since IEN would only output a single number, w_ae needs to be
% oriented the correct way since MATLAB pulls the numbers in column order,
% not row order.  w_ae(2) is second row first column 

%% Initialize all the things from the lecture notes

Ra = zeros(n_loc,1);
dRa_dx = zeros(n_loc,1);
dRa_dy = zeros(n_loc,1);
dRa_dXi1 = zeros(n_loc,1);
dRa_dXi2 = zeros(n_loc,1);
x = zeros(2,1);  % since this is 2d
J = zeros(2);
w_b = 0;
dwb_dXi1 = 0;
dwb_dXi2 = 0;

B = zeros(n_loc,1);
dBa_dXi1 = zeros(n_loc,1);
dBa_dXi2 = zeros(n_loc,1);

%% Now wade through the garbage
for a = 1:n_loc
    [i_1,i_2] = get_row_col(a,n_loc);  % I switched these outputs
    [B(a),dBa_dXi1(a),dBa_dXi2(a)] = Bernstein_basis_deriv(xi_1,p,i_1,Xi_1,xi_2,i_2,Xi_2);
    
    w_b = w_b + w_be(i_1,i_2,e)*B(a);  % these three lines are the weighting and derivatives sections
    dwb_dXi1 = dwb_dXi1 + w_be(i_1,i_2,e)*dBa_dXi1(a);
    dwb_dXi2 = dwb_dXi2 + w_be(i_1,i_2,e)*dBa_dXi2(a);
    
    % This exhausts all Xi_1's before moving to the next Xi_1 
    
end

w_ae_trans = w_ae';

for a = 1:n_loc
    % Basis Functions and Parametric Derivatives
    for b = 1:n_loc
        Ra(a) = Ra(a) + w_ae_trans(IEN(a,e))*C{e}(a,b)*B(b)/w_b;
        dRa_dXi1(a) = dRa_dXi1(a) + w_ae_trans(IEN(a,e))*C{e}(a,b)*(dBa_dXi1(b)/w_b - dwb_dXi1*B(b)/(w_b^2));
        dRa_dXi2(a) = dRa_dXi2(a) + w_ae_trans(IEN(a,e))*C{e}(a,b)*(dBa_dXi2(b)/w_b - dwb_dXi2*B(b)/(w_b^2));
    end
end

% Physical Space Quantities
for a = 1:n_loc    % this does the modular arithmetic to get the correct row and column
    [row,col] = get_row_col(a,n_loc);    % should be row,col

    point = P{row,col,e};
    x = x + w_be(row,col,e).*point.*B(a)./w_b;
    J(1,1) = J(1,1) + w_be(row,col,e)*point(1)*(dBa_dXi1(a)/w_b - dwb_dXi1*B(a)/w_b^2);
    J(1,2) = J(1,2) + w_be(row,col,e)*point(1)*(dBa_dXi2(a)/w_b - dwb_dXi2*B(a)/w_b^2);
    J(2,1) = J(2,1) + w_be(row,col,e)*point(2)*(dBa_dXi1(a)/w_b - dwb_dXi1*B(a)/w_b^2);
    J(2,2) = J(2,2) + w_be(row,col,e)*point(2)*(dBa_dXi2(a)/w_b - dwb_dXi2*B(a)/w_b^2);
    
end

Xi_x = inv(J);
% Phyisical Derivatives
for a = 1:n_loc
    dRa_dx(a) = dRa_dXi1(a)*Xi_x(1,1) + dRa_dXi2(a)*Xi_x(2,1);
    dRa_dy(a) = dRa_dXi1(a)*Xi_x(1,2) + dRa_dXi2(a)*Xi_x(2,2);
    
end

end

