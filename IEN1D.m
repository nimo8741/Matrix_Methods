function [IEN] = IEN1D(n,p,Xi)
% This function computes the IEN array for a given knot vector.  This means
% that it computes the mapping from the local basis function number and
% element number to its corresponding global basis function
%
%
% Inputs: n - number of basis functions
%         p - degree of basis functions
%        Xi - knot vector defining the basis functions

l = p + 1;
e = 1;

while l < n + 1
    for a = 1:p+1
        IEN(a,e) = (l + a) - (p + 1);
    end
    
    l = l + 1;
    while Xi(l+1) == Xi(l) && (l < n+1)
        l = l + 1;
    end
    
    if l < n+1
        e = e + 1;
    end
end

end