function [N] = getN(xi,i,p,Xi)
%% Perform special p = 0 case
if p == 0
    if Xi(i) <= xi && xi < Xi(i+1)
        N = 1;
    else
        N = 0;
    end
else
    %% Everything else
    N_l = (xi - Xi(i))/(Xi(i+p) - Xi(i))*getN(xi,i,p-1,Xi);
    if isnan(N_l)
        N_l = 0;
    end
    N_r = ((Xi(i+p+1) - xi)/(Xi(i+p+1) - Xi(i+1)))*getN(xi,i+1,p-1,Xi);
    if isnan(N_r)
        N_r = 0;
    end
    N = N_l + N_r;
    
    % Throw in this error check to make sure that the value of the nurb is
    % 1 for the last data point on the last basis function
    if xi == Xi(end) & i == (length(Xi)-(p+1))
        N = 1;
    end
    
end