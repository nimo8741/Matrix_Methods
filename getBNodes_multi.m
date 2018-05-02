function [bNodes] = getBNodes_multi(IEN, P, y_coor)
    % for here I need to go through all of the 
    [x,y,z] = size(P);
    bNodes = [];
    for k =1:z
        for i = 1:x
            for j = 1:y
                
                if P{i,j,k}(2) == y_coor
                    bNodes = [bNodes;IEN((j-1)*x + i, k)];
                end
                
            end
        end
    end

    bNodes = unique(bNodes);


end