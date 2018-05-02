function [d] = Heat_Conduction(p_1,n_1,n_2,Xi_1,Xi_2,P,w_be,n_q,IEN,C,n_el,w_e,w_q,quad_p,problem)

pre_max = max(max(IEN));
K = zeros(pre_max);
F = zeros(pre_max,1);

switch problem
    case 1
        %% Construct the Boundary Conditions arrays
        % since this is a single element, it is so much easier
        % if the boundary condition value is empty, it isn't constrained
        
        % inner curved edge is side 1
        % side to the right of that (counter clock-wise) is side 2
        % outer curved edge is side 3
        % remaining side is side 4
        
        BC = [1;0;1;1;0;1;1;0;1];
        Robin = [0;0;0;0];  % there are no robin boundaries
        Neumann = [0;1;0;1];
        g = [200;69;70;200;69;70;200;69;70];  % this is the dirichlet data vector, 69 = don't care
        k = 385;  % w/(m*k)  constant from the homework
        f = 0;   % no heat generation
        h = 0;    % no applied heat flux
        beta = 0;
        U_R = 69;
        
        
        
    case 2
        %% Define the Boundary Condition Constants for Problem 4 Part 1
        
        % inner right angled 2 edges are side 1
        % side to the right of that (counter clock-wise) is side 2
        % outer curved edge is side 3
        % remaining side is side 4
        
        
        BC = zeros(max(max(IEN)),1);  % this is the global Dirichlet boundary condition array. It does not have enough entries if there are more than one element.
        % 15 for the 15 pre-extraction nodes
%          BC(3:3:15) = 1;
%          BC(1:3:13) = 1;
        
        
        Robin = [0,0;0,0;1,1;0,0];  % this is for each of the sides on each of the elements   third set are ones
        Neumann = [1,1;0,0;0,0;0,0];  % this is for each fo the sides on each of the elements  first set are ones
        
        g = [300;69;500;300;69;500;300;69;500;300;69;500;300;69;500];  % this is the dirichlet data vector, 69 = don't care
        
        
        k = 157;  % w/(m*k)  constant from the homework
        f = 0;   % no heat generation
        h = 50000;    % no convection
        beta = 250;
        U_R = 30;
        
    case 3
        %% Define the Boundary Condition Constants for test box
        
        % right side is side 1
        % top is side 2
        % left is side 3
        % bottom is side 4
        
        
        BC = zeros(pre_max,1);
%         BC(1:5) = 1;
%         BC(21:25) = 1;
        BC(1:3) = 1;
        BC(7:9) = 1;
        
        Robin = [0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0];  % this is for each of the sides on each of the elements
        Neumann = [0,0,0,0;0,0,0,0;0,0,0,0;0,0,0,0];  % this is for each fo the sides on each of the elements
        g = zeros(pre_max,1);
%         g(1:5) = 20;
%         g(21:25) = 50;
        g = getDirichlet(P,IEN);
%         g(1:3) = 20;
%         g(7:9) = 50;
        
        
        
        k = 157;  % w/(m*k)  constant from the homework
        f = 0;   % no heat generation
        h = 5000;    % no convection
        beta = 250;
        U_R = 30;
        
        
        
    case 4
end
%% Step 2: Construct the Matrix System

for elem = 1:n_el
    [k_e,f_e,n_loc] = Element_Formation(elem,n_q,quad_p,C,P,w_be,w_e,w_q,Neumann,Robin,k,f,h,beta,U_R,p_1,Xi_1,Xi_2,IEN);
    [K,F] = Element_Assembly(elem,k_e,f_e,IEN,BC,g,K,F,n_loc);
end
for i = 1:pre_max
    if BC(i) == 1
        K(i,i) = 1;
        F(i) = g(i);
    end
end
k_e
%% Step 3: Solve the Matrix System
d_temp = K\F;
%fprintf("Time for QR\n");
%tic
%d_temp = QRFact(K,F);
%toc

%fprintf("Time for LU\n");
%tic
%d_temp = LUsolve(K,F);
%toc
% now reshape d so it matches what plot temp is expecting
count = 1;
for i = 1:n_1
    for j = 1:n_2
        d(i,j) = d_temp(count);
        count = count + 1;
    end
end

end

