function [error] = L2_error(X,Y,temp,u_i,u_o,r_i,r_o)

% figure out the radius of each evaluated point
% since all the temps at the same radius are the same, only need to go down
% a single column of the data matrices
center = [0.05;0];
error = 0;
r(1) = r_i;
for i = 1:length(X) - 1
    point = [X(i);Y(i)];
    r(i+1) = norm(point - center);
    u(i) = (u_o*log(r(i+1)/r_i) - u_i*log(r(i+1)/r_o))/log(r_o/r_i);
    error = error + (u(i) - temp(i))^2*(r(i+1) - r(i));
end
error = sqrt(error);

end