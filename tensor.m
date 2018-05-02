function [result] = tensor(C1,C2)
% need  matrices as the inputs

[a,b] = size(C1);

result = [];
for i = 1:a
    temp = [];
    for j = 1:b
        temp = [temp,C1(i,j)*C2]; 
    end
    if i == 1
        result = temp;
    else
        result = [result;temp];
    end
end

end