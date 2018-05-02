function [p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w,IEN,C,n_el,w_pre,P_post,Xi_1Parent,Xi_2Parent] = Prob4_geometry()
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

Xi_1 = [0,0,0,1,1,2,2,2];
Xi_2 = [0,0,0,1,1,1];

% Xi_1 = [0,0,0,1,1,1];      %  REMOVE THIS LATER

n_1 = length(Xi_1) - (p_1+1);
n_2 = length(Xi_2) - (p_2+1);

r = 12.5/1000;
w_edge = 5/1000;  % this is the variable w from the homework'
center = [r,0];

% Xi_2 changes column-wise, Xi_1 changes row-wise this will be a 5x3
P = {[(r - w_edge/2),0],     'dont know',            [0,0];
     'dont know',               'dont know',         'dont know';
     'dont know',                'dont know',         'dont know';
     'dont know',               'dont know',          'dont know';
     'dont know',                'dont know',          'dont know'};
 
% fill in the easy i dont knows
P{1,2} = P{1,1}/2;
P{2,1} = P{1,1} + [0,w_edge/4];
P{3,1} = P{1,1} + [0,w_edge/2];
P{4,1} = P{3,1} + [w_edge/4,0];
P{5,1} = P{4,1} + [w_edge/4,0];

P{5,3} = center + [0,r];
P{5,2} = (P{5,1} + P{5,3})/2;

% Now the third level of Xi_2
P{3,3} = [r - r*cosd(45),r*sind(45)];
[P{2,3},~] = get_intermediate(P{1,3},P{3,3},center);
[P{4,3},~] = get_intermediate(P{3,3},P{5,3},center);

% now interpolate for the second layer
P{2,2} = (P{2,1} + P{2,3})/2;
P{3,2} = (P{3,1} + P{3,3})/2;
P{4,2} = (P{4,1} + P{4,3})/2;

% P = P(1:3,:);     %  This is to make it just the first element REMOVE THIS LATER

%% Do the Weights
% weight for the circular arcs are cos(theta/2)
w_1 = [1,cosd(22.5),1,cosd(22.5),1]';
w_2 = [1,1,1];
% w_1 = [1,cosd(22.5),1]';   %REMOVE THIS LATER
w_pre = tensor(w_1,w_2);

%NURBS_Surface_elem(2,p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w_pre);  % the generated
% geometry checks out so I don't need to do it every time

%% Now perform extraction
[n_el,C,IEN] = Extract_Basis(p_1,p_2,n_1,n_2,Xi_1,Xi_2);
[Xi_1] = refine_knot(Xi_1,p_1);
[Xi_2] = refine_knot(Xi_2,p_2);
[P_post,w] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P,w_pre,max(Xi_1),max(Xi_2),Xi_1,Xi_2,n_1,n_2);
n_1 = p_1+1;
n_2 = p_2+1;
Xi_1Parent = [0,0,0,1,1,1];
Xi_2Parent = [0,0,0,1,1,1];
%NURBS_Surface_elem(2,p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post,w);




end