function [] = NURBS_Surface(d,p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w_1,w_2)
%% Set up parameters
q = 30;
% data = zeros(q-1,d);
range_1 = linspace(Xi_1(1),Xi_1(end),q);
% range_1 = range_1(1:end-1);
range_2 = linspace(Xi_2(1),Xi_2(end),q);
% range_2 = range_2(1:end-1);
data = zeros(length(range_1)*length(range_2),d);

%% Loop through all the basis and plot
for i = 1:n_1
    for j = 1:n_2  % i and j are the indexes of the basis functions which are to be evaluated
        count = 1;
        for k = range_1
            for m = range_2
                nurby = P{i,j}*NURBS_2D(k,m,i,j,p_1,p_2,n_1,n_2,Xi_1,Xi_2,w_1,w_2);
                for h = 1:d
                    data(count,h) = data(count,h) + nurby(h);
                end
                count = count + 1;
            end
        end
    end
end

% Plotting routine
figure;hold on
axis([0 55/1000 0 55/1000 0.9 1.1])
axis equal
grid on

if d == 2
    X = reshape(data(:,1),q,q);
    Y = reshape(data(:,2),q,q);
    Z = ones(q,q);
    
    
    surf(X,Y,Z);hold on
    for i = 1:n_1
        for j = 1:n_2
            scatter3(P{i,j}(1),P{i,j}(2),1,20,'r','filled')
        end
    end
elseif d == 3
    X = reshape(data(:,1),q,q);
    Y = reshape(data(:,2),q,q);
    Z = reshape(data(:,3),q,q);
    X(:,q) = X(:,1);
    Y(:,q) = Y(:,1);
    Z(:,q) = Z(:,1);
    
    
    surf(X,Y,Z);hold on
    %     scatter3(data(:,1),data(:,2),data(:,3),20,'b.');hold on
    for i = 1:n_1
        for j = 1:n_2
            scatter3(P{i,j}(1),P{i,j}(2),P{i,j}(3),'r','filled')
        end
    end
end

% need to output the physical geometery points

end

