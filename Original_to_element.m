function [output] = Original_to_element(p,n,Xi)
% p = degree
% n = number of basis functions
% Xi = knot vector
E_contents = cell(1,max(Xi));

span = zeros(n,2);
for i = 1:n
    span(i,1) = Xi(i);
    span(i,2) = Xi(i+p+1);
    for j = 1:max(Xi)
        if span(i,1) <= j-1 && span(i,2) >= j
            E_contents{j} = [E_contents{j};i];
        end       
        
    end
end


output = cell2mat(E_contents);

end