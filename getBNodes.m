function [bNodes] = getBNodes(IEN, P)
    % for here I need to go through all of the 
    [x,y,z] = size(P);
    bNodes = [];
    for k =1:z
        for i = 1:x
            for j = 1:y
                
                if norm(P{i,j,k}) >= 0.49
                    bNodes = [bNodes;IEN((j-1)*y + i, k)];
                end
                
            end
        end
    end

    bNodes = unique(bNodes);


end