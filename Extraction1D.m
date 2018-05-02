function [n_el,C] = Extraction1D(n,p,Xi)
% This function performs a 1D Bezier extraction on an unrefined knot vector
%
% This returns the number of extraction operators as well as the set of
% operators themselves
%
% Inputs: n - number of basis functions
%         p - degree of basis functions
%        Xi - knot vector defining the basis functions

% Set First Element to [Xi_a,Xi_b)
a = p + 1;
b = a + 1;
n_el = 1;           % initialize number of elements
C{1} = eye(p+1);    % initialize first extraction operator inside cell array as identity matrix

while b < (n + p + 1)
    C{n_el+1} = eye(p+1);     % initialize next operator
    i = b;
    
    while b < (n+p+1) && (Xi(b+1) == Xi(b))
        b = b + 1;
    end
    
    mult = b - i + 1;    % compute multiplicity of b
    
    if mult < p
        numer = Xi(b) - Xi(a);
        
        for j = p:-1:(mult+1)
            alpha_s(j-mult) = numer./(Xi(a+j) - Xi(a));
        end
        
        r = p - mult;     % compute number of added knots needed
        
        for j = 1:r
            save = r - j + 1;
            s = mult + j;
            
            for k = p+1:-1:s+1
                alpha = alpha_s(k-s);
                C{n_el}(:,k) = alpha*C{n_el}(:,k) + (1 - alpha)*C{n_el}(:,k-1);
            end
            
            if b < (n + p + 1)
                C{n_el + 1}(save:j+save,save) = C{n_el}(p-j+1:p+1,p+1);
            end
        end
    end
    % set next element
    if b < n + p + 1
        a = b;
        b = a + 1;
        n_el = n_el + 1;
    end
end

% remove the last operator
C(end) = [];
end
