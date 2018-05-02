function [P_b,w_b] = Extract_Geometry(d,p_1,p_2,n_el,C_operators,IEN,P,weight,n_el1,n_el2,Xi_1,Xi_2,n_1,n_2)


% project the control points
[x,y] = size(P);
for i = 1:x
    for j = 1:y
        P{i,j} = [P{i,j}*weight(i,j),weight(i,j)];
    end
end


% now need to calculate the localized control points

elems_1 = Original_to_element(p_2,n_1,Xi_1);
elems_2 = Original_to_element(p_2,n_2,Xi_2);
P_b = cell(3,3,n_el1*n_el2);


for i = 1:n_el
    col = ceil(i/n_el1);   % i switched which was row and which was column
    row = mod(i,n_el1);
    if row == 0
        row = n_el1;
    end
    
    count = 1;
    P_local = [];

    for j = 1:p_1+1
        for k = 1:p_2+1
            P_local{count,1} = P{elems_1(j,row),elems_2(k,col)}; % this makes the vector to multiply by the 9x9 extraction operators
            count = count + 1;
        end
    end
    P_local = cell2mat(P_local);
    % now multiply by the extraction operators and assign it to the right
    % bezier control point.  These are determined by the IEN array
    
    for j = 1:count-1   % this goes up to 9 for two degree 2's
        row = ceil(j/3);
        col = mod(j,3);
        if col == 0
            col = 3;
        end
        % store this so each sheet is an element, each Xi_1 changes row
        % wise and Xi_2 changes column wise
        for l = 1:d+1
            temp = (C_operators{i})'*P_local(:,l);  % remember to transpose
            P_b{row,col,i} = [P_b{row,col,i},temp(j)]; 
        end
        % now extract the weights and go back a dimension
        w_b(row,col,i) = P_b{row,col,i}(d+1);
        P_b{row,col,i}(d+1) = [];
        P_b{row,col,i} = P_b{row,col,i}(:)/w_b(row,col,i);
    end
       
    
end

end