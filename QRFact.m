function [X] = QRFact(A,b)
%clear all; close all;
%A = [2 1 0 0;1 2 1 0; 0 1 2 1; 0 0 1 2];

% %Assume input matrix is square 
dim = size(A);

U = zeros(dim(1),dim(2));
Q = zeros(dim(1),dim(2));
B = zeros(dim(1),dim(2));
sum1 = 0;

for i = 1:dim(1)
    if i == 1
        U(:,1) = A(:,1);
    else
           
            for j = 2:dim(2)
                
                    if j > i 
                        continue
                    else 
                    sum = (A(:,i)'*U(:,j-1)/(U(:,j-1)'*U(:,j-1))*U(:,j-1));
                    sum1 = sum1 + sum;
                    end
            end             
            U(:,i) = A(:,i)- sum1 ;
            sum1 = 0;
     end 
    
    Q(:,i) = U(:,i)/norm(U(:,i));
end 

R = zeros(dim(1),dim(2));
for i = 1:dim(1)
    
    for j = i:dim(2)
        R(i,j) = (A(:,j)'*Q(:,i)); 
    
    end 
end 


    len = length(R);
    I  = eye(len);
    M  = [R I];
    S = R;
    for row = 1:len
        M(row,:) = M(row,:)/M(row,row);
        S(row,:) = S(row,:)/S(row,row);
        if det(S) == 1
            for idx = 2:len
                for j = idx-1:-1:1
                   M(j,:) = M(j,:) - M(j,idx)*M(idx,:); 
                end
                
                
            end
        else 
            continue
        end
    end
    RI = M(:,len+1:end);
    
    
    X = RI*Q'*b;
    
end




