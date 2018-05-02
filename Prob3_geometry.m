function [p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w,IEN,C,n_el,w_pre] = Prob3_geometry()
%% Outputs:
% p_1: polynomial degree in the Xi_1 direction
% p_2: ploynomial degree in the Xi_2 direction
% n_1: number of basis functions in the Xi_1 direction
% n_2: number of basis functions in the Xi_2 direction
% Xi_1: Knot vector in the first dimension
% Xi_2: Knot vector in the second dimension
% P: Organized set of control points
% w: Organized set of basis weights
% IEN: IEN Array
% C: Extraction Operators
% n_el: number of elements
% w_pre: pre extraction weights

% I will use p = 2 for each direction so with three basis functions in each
% direction

%% Define the easy things
p_1 = 2;
p_2 = 2;

n_1 = 3;
n_2 = 3;

Xi_1 = [0,0,0,1,1,1];
Xi_2 = [0,0,0,1,1,1];

% Xi_2 changes column-wise, Xi_1 changes row-wise
P = {[10/1000,0],               [5/1000,0],            [0,0];
     'dont know',               'dont know',         'dont know';
     [50/1000,40/1000],       [50/1000,45/1000]    [50/1000,50/1000]};
 
% now fill in the i dont knows

[P{2,1},~] = get_intermediate(P{1,1},P{3,1},[50/1000,0]);

[P{2,3},~] = get_intermediate(P{1,3},P{3,3},[50/1000,0]);

P{2,2} = (P{2,1} + P{2,3})/2;
P = P';
%% Do the Weights
w_1 = [1,1/sqrt(2),1];
w_2 = [1,1,1];
w_pre = tensor(w_2',w_1);

% NURBS_Surface_elem(2,p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w);  % the generated
% geometry checks out so I don't need to do it every time

%% Now perform extraction
[n_el,C,IEN] = Extract_Basis(p_1,p_2,n_1,n_2,Xi_1,Xi_2);
[Xi_1] = refine_knot(Xi_1,p_1);
[Xi_2] = refine_knot(Xi_2,p_2);
[P,w] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P,w_pre,max(Xi_1),max(Xi_1),Xi_1,Xi_2,n_1,n_2);
% NURBS_Surface_elem(2,p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w);


end
