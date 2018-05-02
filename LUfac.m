function [L,U] = LUfac(A)
% Performs regular Gaussian elimination on rectangular matrix K
%
% Grant Dunbar
% 4/10/2018
    [m,n] = size(A); % find size of input
    if m ~= 1 && n ~= 1 % if input is a matrix and not a scalar...
        L = diag(ones(m,1),0); % form L matrix
        U = zeros(m,n); % form U matrix
        U(1,:) = A(1,:); % first row of the U matrix will equal the k matrix
        for i = 2:m % for every remaining row...
            U(i,:) = A(i,:)-A(1,:).*A(i,1)/A(1,1); % RGE upper triangular row entry
            L(i,1) = A(i,1)/A(1,1); % RGE lower triangular row entry
        end % end of for loop
        [l,u] = LUfac(U(2:end,2:end)); % recurse allll the way down to solve the matrix
        if length(u) ~= 0 && length(l) ~= 0 % if there is an output from the recursion
            U(2:end,2:end) = u; % put the u output into its place
            L(2:end,2:end) = l; % put the l output into its place
        end % end of if statement
    else % if input is a scalar
        U = []; % cannot be factored
        L = []; % cannot be factored
    end % end of if statement
end % end of function