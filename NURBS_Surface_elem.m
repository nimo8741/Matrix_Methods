function [X,Y,Z] = NURBS_Surface_elem(d,p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w)
%% Set up parameters
q = 20;
[~,~,z] = size(P);
% data = zeros(q-1,d);
range_1 = linspace(Xi_1(1),Xi_1(end),q);
% range_1 = range_1(1:end-1);
range_2 = linspace(Xi_2(1),Xi_2(end),q);
% range_2 = range_2(1:end-1);
data = zeros(length(range_1)*length(range_2)*z,d);

%% Loop through all the basis and plot
elem_length = q^2;
for elem = 1:z
    for i = 1:n_1
        for j = 1:n_2  % i and j are the indexes of the basis functions which are to be evaluated
            count = 1;
            for k = range_1
                for m = range_2
                    nurby = P{i,j,elem}*NURBS_2D_elem(k,m,i,j,p_1,p_2,n_1,n_2,Xi_1,Xi_2,w(:,:,elem));
                    for h = 1:d
                        data(count+(elem_length*(elem-1)),h) = data(count+(elem_length*(elem-1)),h) + nurby(h);% the elem_length jazz is so that the data points are not overwritten when they would exist in different elements
                    end
                    count = count + 1;
                end
            end
        end
    end
end

%% Plotting routine
%figure;hold on
%axis equal
%grid on
if d == 2
    cur_index = 1;
    for i = 1:z
        data_cur = data(cur_index:cur_index+q^2-1,:);
        X = reshape(data_cur(:,1),q,q);
        Y = reshape(data_cur(:,2),q,q);
        Z = ones(q,q);
        %surf(X,Y,Z)
        
        for k = 1:n_1
            for j = 1:n_2
                scatter3(P{k,j,i}(1),P{k,j,i}(2),1,'r','filled')
            end
        end
        cur_index = cur_index + q^2;
        
    end
    axis([min(min(data(:,1)))-abs(0.1*min(min(data(:,1)))) 1.1*max(max(data(:,1))) min(min(data(:,2)))-abs(0.1*min(min(data(:,2)))) 1.1*max(max(data(:,2))) 0.9 1.1])
    
    view(2)
elseif d == 3  % need to split this up into elements
    %     elem_num = 17;
    cur_index = 1;%+elem_num*q^2;
    
    for i = 1:z
        data_cur = data(cur_index:cur_index+q^2-1,:);
        X = reshape(data_cur(:,1),q,q);
        Y = reshape(data_cur(:,2),q,q);
        Z = reshape(data_cur(:,3),q,q);
        cur_index = cur_index + q^2;
        surf(X,Y,Z)
    end
    
    
    %     scatter3(data(:,1),data(:,2),data(:,3),20,'b.');hold on
    %     for elem = 1:z
    %         for i = 1:n_1
    %             for j = 1:n_2
    %                 scatter3(P{i,j,elem}(1),P{i,j,elem}(2),P{i,j,elem}(3),'r','filled')
    %             end
    %         end
    %     end
end

end

