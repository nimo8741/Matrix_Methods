function [K,F] = Element_Assembly(e,k_e,f_e,IEN,BC,g,K,F,n_loc)
%% Inputs 
% e: element number
% k_e: Stiffness matrix for the current element
% f_e: the force vector for the current element
% IEN: IEN array to go from local to global
% BC: Boundary conditions?
% g: Vector of Dirichlet data
% K: Master Stiffness matrix
% F: Master Force vector

%% Outputs
% K: Updated Master Stiffness matrix
% F: Master Force Vector

%% Here we go!
for a = 1:n_loc
    i = IEN(a,e);
    if BC(i) == 0
        for b = 1:n_loc
            j = IEN(b,e);
            if BC(j) == 0
                
                K(i,j) = K(i,j) + k_e(a,b);
            else
                F(i) = F(i) - k_e(a,b)*g(j);
            end
        end
        F(i) = F(i) + f_e(a);
    end
end                

end

            
            