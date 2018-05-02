function [IEN] = checkNodes(P2,P3,P4,P5,Pall,IEN,IEN_Master,p)
% the IEN array is for P2
[x,y,z] = size(P2);   % I already know that all of the control point matrices

% now I need to loop through all of the nodes in the current patch
if (p == 2)
    P_cur = P2;
elseif p == 3
    P_cur = P3;
elseif p == 4
    P_cur = P4;
elseif p == 5
    P_cur = P5;
end

icr = max(max(IEN_Master)) + 1;

for k = 1:z
    for j = 1:y
        for i = 1:x
            % now I need to loop through all of the nodes in the lower
            % patches
            found = false;
            for patch = p-1:-1:1
                if (patch == 1)
                    P_master = Pall(:,:,1);
                elseif patch == 2
                    P_master = Pall(:,:,2);
                elseif patch == 3
                    P_master = Pall(:,:,3);
                elseif patch == 4
                    P_master = Pall(:,:,4);
                end
                % now loop through P_master to find a match
                for q = 1:z
                    for n = 1:y
                        for m = 1:x
                            if P_cur{i,j,k} == P_master{m,n,q}
                                % this means we have a match
                                match = IEN_Master((n-1)*y + m,patch);
                                found = true;
                                
                            end
                        end
                    end
                end
            end
            % Now do all of the IEN fixing
            if found == true
                IEN((j-1)*y + i, k) = match;
                
            else
                % if a match was not found then I need to increase the IEN
                % entry number of all members with the same number
                
                % this is assuming that this has not yet been touched
                
                % to know if it has been touched, the value of the IEN will
                % be larger than max(max(IEN_Master))
                
                if IEN((j-1)*y+i,k) <= max(max(IEN_Master))
                    % now find all the entries with the same value 
                    % the valid values are going to be those at or beyond
                    % the current spot in the IEN array
                    
                    B = find(IEN == IEN((j-1)*y+i,k));
                    % now loop through B and remove the elements I don't
                    % want to change
                    limit = (k-1)*x*y + (j-1)*y+i; 
                    c = 1;
                    len = length(B);
                    while c <= len
                        if B(c) < limit
                            B(c) = [];
                            c = c - 1;
                            len = len - 1;
                        end
                        c = c + 1;
                        
                    end
                    IEN(B) = icr;
                    icr = icr + 1;
                    
                end
                
            end
        end
    end
    
end


