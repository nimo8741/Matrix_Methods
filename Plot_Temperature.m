function [X,Y,temp] = Plot_Temperature(p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w,d)

% plots the temperature field over the physical geometery

% first get the physical geometery from th NURBS_Surface function
% f = figure;hold on
figure; hold on
[X,Y,Z] = NURBS_Surface_elem(2,p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w);  % this is the physical geometry

% X = X';

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
                nurby = d(i,j)*NURBS_2D_elem(k,m,i,j,p_1,p_2,n_1,n_2,Xi_1,Xi_2,w);
                temp(count) = temp(count) + nurby;%
                count = count + 1;
            end
        end
    end
end

temp = reshape(temp,q,q);
title('Temperature Throughout Domain','FontSize',14)
xlabel('X Location [m]')
ylabel('Y Location [m]')

surf(X,Y,Z,temp,'EdgeAlpha',0);
NURBS_Surface_elem(2,p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w);  % this is the physical geometry

shading interp
view(2)
axis equal
grid on
h = colorbar;
ylabel(h, 'Temperature [C]')
caxis([min(min(temp)) max(max(temp))])

end