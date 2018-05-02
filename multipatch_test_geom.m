function [p_1,p_2,n_1,n_2,Xi_1,Xi_2,w1,IEN,C,n_el,w_pre,P_post1,P_post2,P1,P2,Xi_1Parent,Xi_2Parent] = multipatch_test_geom()

p_1 = 2;
p_2 = 2;

Xi_1 = [0,0,0,1,1,2,2,2];
Xi_2 = [0,0,0,1,1,2,2,2];    % for simplicity, every knot vector pair will be the same for every element

n_1 = length(Xi_1) - (p_1+1);
n_2 = length(Xi_2) - (p_2+1);


%% now go through an define the control points for the left square
P1 = {[0,0],[1,0],[2,0],[3,0],[4,0];
    [0,1],[1,1],[2,1],[3,1],[4,1];
    [0,2],[1,2],[2,2],[3,2],[4,2];
    [0,3],[1,3],[2,3],[3,3],[4,3];
    [0,4],[1,4],[2,4],[3,4],[4,4]};

%% Now fill in the point on the top arc
P2 = {[4,0],[5,0],[6,0],[7,0],[8,0];   % this is the straight edge
    [4,1],[5,1],[6,1],[7,1],[8,1];
    [4,2],[5,2],[6,2],[7,2],[8,2];    % this is mid way in the element
    [4,3],[5,3],[6,3],[7,3],[8,3];
    [4,4],[5,4],[6,4],[7,4],[8,4]};

%% Now do all of the weights


w_1 = [1,1,1,1,1]';
w_2 = [1,1,1,1,1];

w_pre = tensor(w_1,w_2);


[n_el,C,IEN] = Extract_Basis(p_1,p_2,n_1,n_2,Xi_1,Xi_2);  % I only need to do this once since all basis are the same
Xi_1 = refine_knot(Xi_1,p_1);
Xi_2 = refine_knot(Xi_2,p_2);

% now extract the geometry
[P_post1,w1] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P1,w_pre,max(Xi_1), max(Xi_2),Xi_1,Xi_2,n_1,n_2);
[P_post2,~] = Extract_Geometry(2,p_1,p_2,n_el,C,IEN,P2,w_pre,max(Xi_1), max(Xi_2),Xi_1,Xi_2,n_1,n_2);

n_el = n_el+n_el;

n_1 = p_1+1;
n_2 = p_2+1;
Xi_1Parent = [0,0,0,1,1,1];
Xi_2Parent = [0,0,0,1,1,1];


NURBS_Surface_elem_circle(2,p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post1,w1);
NURBS_Surface_elem_circle(2,p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post2,w1);





end