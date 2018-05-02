function [g] = getDirichlet(P,IEN)

for i = 1:max(max(IEN))
    % now I need to find the first instance of the local basis function
    % number within on of the patches for each IEN member
    [row,col] = find(IEN == i,1);
    
    cur_patch = P(:,:,col);
    if cur_patch{row}(1) < 0
        g(i) = -100;
    elseif cur_patch{row}(1) > 0
        g(i) = 100;
    else 
        g(i) = 0;
    end
    %g(i) = cur_patch{row}(1)*100;
end

end