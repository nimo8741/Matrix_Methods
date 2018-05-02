function x = LUsolve(A,b)
    [m,n] = size(A); % get size of A
    if m ~= n || rank(A) < m % check for input problems
        error('System not solvable.')
    end
    in = zeros(m,n+1); % make matrix that will hold both A and b for LU decomposition
    in(:,1:n) = A; % add in A
    in(:,n+1) = b; % add in b
    [~,out]=LUfac(in); % get [U,b] out
    for i = m:-1:2
        out(i,end) = out(i,end)/out(i,i);
        %out(i,i) = 1;
        for j = i-1:-1:1
            out(j,end) = out(j,end)-out(i,end)*out(j,i);
            %out(j,i) = 0;
        end
    end
    out(1,end) = out(1,end)/out(1,1);
    x = out(:,end);
end