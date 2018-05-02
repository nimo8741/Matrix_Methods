function [d_temp] = Heat_Conduction_multi(p_1,n_1,n_2,Xi_1,Xi_2,P,w_be,n_q,IEN,C,n_el,w_e,w_q,quad_p)

pre_max = max(max(IEN));
K = zeros(pre_max);
F = zeros(pre_max,1);

%% Define the Boundary Condition Constants for the circular problem

% dirichlet condition of x at all points


BC = zeros(max(max(IEN)),1);  % this is the global Dirichlet boundary condition array. It does not have enough entries if there are more than one element.

b_nodes1 = getBNodes_multi(IEN, P, 4);


BC(b_nodes1) = 1;

b_nodes2 = getBNodes_multi(IEN,P,0);
BC(b_nodes2) = 1;

Robin = zeros(4,n_el);
Neumann = zeros(4,n_el);
%Robin = [0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,0,0];  % this is for each of the sides on each of the elements   third set are ones
%Neumann = [0,0,0,0,0;0,0,0,0,0;0,0,0,0,0;0,0,0,0,0];  % this is for each fo the sides on each of the elements  first set are ones

g = 50*ones(length(BC),1);
g(b_nodes2) = 700;


k = 300;  % w/(m*k)  constant from the homework
f = 0;   % no heat generation
h = 0;    % no convection
beta = 0;
U_R = 720;

%% Step 2: Construct the Matrix System

for elem = 1:n_el
    [k_e,f_e,n_loc] = Element_Formation_circle(elem,n_q,quad_p,C,P,w_be,w_e,w_q,Neumann,Robin,k,f,h,beta,U_R,p_1,Xi_1,Xi_2,IEN);
    [K,F] = Element_Assembly(elem,k_e,f_e,IEN,BC,g,K,F,n_loc);
end
for i = 1:pre_max
    if BC(i) == 1
        K(i,i) = 1;
        F(i) = g(i);
    end
end

%% Step 3: Solve the Matrix System
d_temp = K\F;


end