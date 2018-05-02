function [] = plot_patches(p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w,d,IEN)

% plots the temperature field over the physical geometery

% first get the physical geometery from th NURBS_Surface function
% f = figure;hold on
[~,~,elem] = size(P);
figure;hold on
temp_max = [];
temp_min = [];


for counter = 1:elem
    [X,Y,Z] = NURBS_Surface_elem_circle(2,p_1,p_2,n_1,n_2,Xi_1,Xi_2,P(:,:,counter),w(:,:,counter));  % this is the physical geometry
    
    q = 20;
    
    [~,~,z] = size(d);
    range_1 = linspace(Xi_1(1),Xi_1(end),q);
    range_2 = linspace(Xi_2(1),Xi_2(end),q);
    temp = zeros(length(range_1)*length(range_2)*z,1);   % 2 for 2 dimensions
    
    %% Loop through all the basis and plot
    for i = 1:n_1
        for j = 1:n_2  % i and j are the indexes of the basis functions which are to be evaluated
            count = 1;
            for k = range_1
                for m = range_2
                    nurby = d(IEN((i-1)*n_1 + j,counter))*NURBS_2D_elem(k,m,i,j,p_1,p_2,n_1,n_2,Xi_1,Xi_2,w(:,:,counter));
                    temp(count) = temp(count) + nurby;%
                    count = count + 1;
                end
            end
        end
    end
    
    temp = reshape(temp,q,q)';
    if isempty(temp_max) || (max(max(temp)) > temp_max)
        temp_max = max(max(temp));
    end
    
    if isempty(temp_min) || (min(min(temp)) < temp_min)
        temp_min = min(min(temp));
    end
    
    surf(X,Y,Z,temp,'EdgeAlpha',0);
    
end

% Now go through and plot control points
for k = 1:elem
    for i = 1:n_1
        for j = 1:n_2
            scatter3(P{i,j,k}(1),P{i,j,k}(2),1.1,'filled','r')
        end
    end 
end

title('Temperature Throughout Domain','FontSize',14)
xlabel('X Location [m]')
ylabel('Y Location [m]')
shading interp
view(2)
axis equal
grid on
h = colorbar;
ylabel(h,'Temperature [C]')
caxis([temp_min temp_max])

end


