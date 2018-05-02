function [P,w2] = get_intermediate(point1,point3,O)
p1 = point1 - O;
p3 = point3 - O;
Omega = acos(dot(p1,p3)/(norm(p1)*norm(p3)))/2;   % this is the half angle between the two outside points

% % Point 2 is just the addition of p1 and p3
% p2 = p1 + p3;
% P = p2 + O;
%% this assumes there are no infinite slopes
islope1 = -p1(1)/p1(2);
islope2 = -p3(1)/p3(2);
if ~isinf(islope1) && ~isinf(islope2)
    b1 = -islope1*point1(1) + point1(2);
    b2 = -islope2*point3(1) + point3(2);
    
    P(1) = (b2 - b1)/(islope1 - islope2);
    P(2) = islope1*P(1) + b1;
elseif isinf(islope1)
    P(1) = point1(1);
    b2 = -islope2*point3(1) + point3(2);
    P(2) = islope2*P(1) + b2;
elseif isinf(islope2)
    P(1) = point3(1);
    b1 = -islope1*point1(1) + point1(2);
    P(2) = islope1*P(1) + b1;
   
end

w2 = cos(Omega);

end