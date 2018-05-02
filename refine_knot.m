function [Xi] = refine_knot(Xi,p)
% skip over whatever the first number is
i = 1;
while Xi(i) == Xi(1)
    i = i + 1;
end

while i   % just keep looping
    start = i;
    % loop through these numbers to find the end of this number
    while Xi(i) == Xi(start) && i < length(Xi)
        i = i + 1;
    end
    
    amount_cur = i - start;
    need = p - amount_cur;
    if i == length(Xi)
        return
    elseif need == 0
%         i = i + 1;
    else
        insert = Xi(start)*ones(1,need);
        Xi = [Xi(1:start),insert,Xi(start+1:end)];
        i = i + need;
    end
end


end