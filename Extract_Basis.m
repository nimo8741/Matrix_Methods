function [n_el,C,IEN] = Extract_Basis(p_1,p_2,n_1,n_2,Xi_1,Xi_2)
%% Extraction 2D  portion
[n_el1, C1] = Extraction1D(n_1,p_1,Xi_1);
[n_el2, C2] = Extraction1D(n_2,p_2,Xi_2);

n_el = n_el1*n_el2;

for e1 = 1:n_el1
    for e2 = 1:n_el2
        e = (e1-1)*n_el2 + e2;
        C{e} = tensor(C1{e1},C2{e2});

    end
end    

%% IEN 2D portion
% need the refined knot vectors
Xi_1_ref = refine_knot(Xi_1,p_1);
Xi_2_ref = refine_knot(Xi_2,p_2);

n_1_ref = length(Xi_1_ref) - (p_1+1);
n_2_ref = length(Xi_2_ref) - (p_2+1);


IEN1 = IEN1D(n_1_ref,p_1,Xi_1_ref);
IEN2 = IEN1D(n_2_ref,p_2,Xi_2_ref);

for e1 = 1:n_el1
    for a1 = 1:p_1+1
        i1 = IEN1(a1,e1);
        
        for e2 = 1:n_el2
            for a2 = 1:p_2+1
                i2 = IEN2(a2,e2);
                e = (e1-1)*n_el2 + e2;
                a = (a1-1)*(p_2+1) + a2;
                i = (i1-1)*n_2_ref +i2;
                IEN(a,e) = i;
            end
        end
    end
end

            



end