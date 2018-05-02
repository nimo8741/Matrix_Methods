function [p_1,p_2,n_1,n_2,Xi_1,Xi_2,w1,w2,IEN,C,n_el,w_pre_s,w_pre,P_post1,P_post2,P_post3, P_post4,P_post5,P1,P2,P3,P4,P5,Xi_1Parent,Xi_2Parent] = circle_geometry()
% I need to define 5 patch that can be combine to create a circle that is 1
% meter in radius or diameter, which ever is easier

%% Outputs:
% p_1: polynomial degree in the Xi_1 direction
% p_2: ploynomial degree in the Xi_2 direction
% n_1: number of basis functions in the Xi_1 direction
% n_2: number of basis functions in the Xi_2 direction
% Xi_1: Knot vector in the first dimension
% Xi_2: Knot vector in the second dimension
% P: Organized set of control points
% w: Organized set of basis weights
% IEN: IEN Array
% C: Extraction Operators
% n_el: number of elements
% w_pre: pre extraction weights

% I will use p = 2 for each direction so with three basis functions in each
% direction because that is sufficient to create circles
p_1 = 2;
p_2 = 2;

Xi_1 = [0,0,0,1,1,1];
Xi_2 = [0,0,0,1,1,1];    % for simplicity, every knot vector pair will be the same for every element

n_1 = length(Xi_1) - (p_1+1);
n_2 = length(Xi_2) - (p_2+1);

% now define some of the geometric parameters

%% now go through an define the control points for the internal square
P1 = {[-0.25,0.25],[0,0.25],[0.25,0.25];
    [-0.25,0],[0,0],[0.25,0];
    [-0.25,-0.25],[0,-0.25],[0.25,-0.25]};
P1 = P1';

%% Now fill in the point on the top arc
P2 = {[-0.25,0.25],[0,0.25],[0.25,0.25];   % this is the straight edge
    [],[],[];    % this is mid way in the element
    [-0.5*cosd(45),0.5*cosd(45)],[],[0.5*cosd(45), 0.5*cosd(45)]};

% now fill in the other points
[P2{3,2},~] = get_intermediate(P2{3,1},P2{3,3},[0,0]); 

P2{2,1} = (P2{1,1} + P2{3,1}) / 2;
P2{2,2} = (P2{1,2} + P2{3,2}) / 2;
P2{2,3} = (P2{1,3} + P2{3,3}) / 2;

% P2 = P2';



%% Now do P3 which is the right arc

P3 = {[0.25,0.25],[0.25,0],[0.25,-0.25];
    [],[],[];
    [0.5*cosd(45),0.5*cosd(45)],[],[0.5*cosd(45),-0.5*cosd(45)]};

% now fill in the other ones
[P3{3,2},~] = get_intermediate(P3{3,1},P3{3,3},[0 0]);

P3{2,1} = (P3{1,1} + P3{3,1}) / 2;
P3{2,2} = (P3{1,2} + P3{3,2}) / 2;
P3{2,3} = (P3{1,3} + P3{3,3}) / 2;

% P3 = P3';

%% Now do P4 which is the bottom arc

P4 = {[0.25,-0.25],[0,-0.25],[-0.25,-0.25];
    [],[],[];
    [0.5*cosd(45),-0.5*cosd(45)],[],[-0.5*cosd(45),-0.5*cosd(45)]};

% now fill in the other ones
[P4{3,2},~] = get_intermediate(P4{3,1},P4{3,3},[0 0]);

P4{2,1} = (P4{1,1} + P4{3,1}) / 2;
P4{2,2} = (P4{1,2} + P4{3,2}) / 2;
P4{2,3} = (P4{1,3} + P4{3,3}) / 2;

% P4 = P4';

%% Now do P5 which is the left arc

P5 = {[-0.25,-0.25],[-0.25,0],[-0.25,0.25];
    [],[],[];
    [-0.5*cosd(45),-0.5*cosd(45)],[],[-0.5*cosd(45),0.5*cosd(45)]};

% now fill in the other ones
[P5{3,2},~] = get_intermediate(P5{3,1},P5{3,3},[0 0]);

P5{2,1} = (P5{1,1} + P5{3,1}) / 2;
P5{2,2} = (P5{1,2} + P5{3,2}) / 2;
P5{2,3} = (P5{1,3} + P5{3,3}) / 2;

% P5 = P5';

%% Now do all of the weights

w_1_s = [1 1 1]';
w_2_s = [1 1 1];

w_1 = [1,cosd(45),1];
w_2 = [1,1,1]';

w_pre = tensor(w_1,w_2);
w_pre_s = tensor(w_1_s,w_2_s);


[n_el,C,IEN] = Extract_Basis(p_1,p_2,n_1,n_2,Xi_1,Xi_2);  % I only need to do this once since all basis are the same
Xi_1 = refine_knot(Xi_1,p_1);
Xi_2 = refine_knot(Xi_2,p_2);

% now extract the geometry
[P_post1,w1] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P1,w_pre_s,max(Xi_1), max(Xi_2),Xi_1,Xi_2,n_1,n_2);
[P_post2,w2] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P2,w_pre,max(Xi_1), max(Xi_2),Xi_1,Xi_2,n_1,n_2);
[P_post3,~] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P3,w_pre,max(Xi_1), max(Xi_2),Xi_1,Xi_2,n_1,n_2);
[P_post4,~] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P4,w_pre,max(Xi_1), max(Xi_2),Xi_1,Xi_2,n_1,n_2);
[P_post5,~] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P5,w_pre,max(Xi_1), max(Xi_2),Xi_1,Xi_2,n_1,n_2);

n_1 = p_1+1;
n_2 = p_2+1;
Xi_1Parent = [0,0,0,1,1,1];
Xi_2Parent = [0,0,0,1,1,1];

% figure; hold on
% NURBS_Surface_elem_circle(2,p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post1,w1);
% NURBS_Surface_elem_circle(2,p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post2,w2);
% NURBS_Surface_elem_circle(2,p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post3,w2);
% NURBS_Surface_elem_circle(2,p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post4,w2);
% NURBS_Surface_elem_circle(2,p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post5,w2);

end

