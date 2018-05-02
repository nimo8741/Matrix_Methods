function M = cholesky(k)
% cholesky decomposition of symmetric matrix k
% K = M'M
%
% Grant Dunbar
% 4/10/2018
[m,~] = size(k); % find size of input matrix
[~,U] = RGE(k); % perform regular gaussian elimination
A = U; % prep A matrix (K = A'D'DA)
D = zeros(m); % diagonal matrix
for i = 1:m % for each row in A...
    D(i,i) = sqrt(A(i,i)); % enter square root of pivot into diagonal matrix
    A(i,:) = A(i,:)/A(i,i); % divide row by its pivot
end % end of for loop
M = D*A; % and finally assemble into K = M'M form
end % end of function