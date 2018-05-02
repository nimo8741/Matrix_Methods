clear all
close all


% set quadrature data
quad_p = [1/2,1/2+(1/2)*sqrt(3/5),1/2-(1/2)*sqrt(3/5)];
n_q = length(quad_p);
w_quad = [4/9,5/18,5/18];
% this quadrature data will be used for the rest of the assignment


%% Step 1: Initialize the Problem this will extract as well
problem = 1;
[p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w,IEN,C,n_el,w_pre] = Prob3_geometry();

[d] = Heat_Conduction(p_1,n_1,n_2,Xi_1,Xi_2,P,w,n_q,IEN,C,n_el,w_pre,w_quad,quad_p,problem);

[X,Y,temp] = Plot_Temperature(p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w,d);

% % now figure out the L2 error
% r_i = 0.04;  % meters
% r_o = 0.05;  % meters
% u_i = 200;
% u_o = 70;
% 
% % error = L2_error(X,Y,temp,u_i,u_o,r_i,r_o);
% 
%% Problem 4 
%Step One: Make the thing

problem = 2;
[p_1,p_2,~,~,Xi_1,Xi_2,P,w,IEN,C,n_el,w_pre,P_post,Xi_1Parent,Xi_2Parent] = Prob4_geometry();


n_1 = length(Xi_1) - (p_1 + 1);
n_2 = length(Xi_2) - (p_2 + 1);
[d] = Heat_Conduction(p_1,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post,w,n_q,IEN,C,n_el,w_pre,w_quad,quad_p,problem);

[X,Y,temp] = Plot_Temperature(p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w_pre,d);

% 
%% Test box

problem = 3;

[p_1,p_2,~,~,Xi_1,Xi_2,P,w,IEN,C,n_el,w_pre,P_post,Xi_1Parent,Xi_2Parent] = box_geometry();


n_1 = length(Xi_1) - (p_1 + 1);
n_2 = length(Xi_2) - (p_2 + 1);
[d] = Heat_Conduction(p_1,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post,w,n_q,IEN,C,n_el,w_pre,w_quad,quad_p,problem);

[X,Y,temp] = Plot_Temperature(p_1,p_2,n_1,n_2,Xi_1,Xi_2,P,w_pre,d);


%% Now the circle of heat conduction
% step 1: make the thing

[p_1,p_2,n_1,n_2,Xi_1,Xi_2,w1,w2,IEN,C,~,w_pre_s,w_pre,P_post1,P_post2,P_post3,P_post4,P_post5,P1,P2,P3,P4,P5,Xi_1Parent,Xi_2Parent] = circle_geometry();

% now need to reconstruct the IEN array so it accounts for the multi patches
[P_post,w,w_pre,C] = combineMats(P_post1,P_post2,P_post3,P_post4,P_post5,w_pre_s,w_pre,w1,w2,C);

IEN = FixIEN(IEN,P_post2,P_post3,P_post4,P_post5,P_post);

% now combine the weights and control points into a more contained matrix
[~,~,z] = size(w);
n_el = z;

n_1_new = length(Xi_1) - (p_1 + 1);
n_2_new = length(Xi_2) - (p_2 + 1);

[d] = Heat_Conduction_circle(p_1,n_1_new,n_2_new,Xi_1Parent,Xi_2Parent,P_post,w,n_q,IEN,C,n_el,w_pre,w_quad,quad_p);

plot_patches(p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post,w,d,IEN);

%% Multi patch test geometry

% step 1: make the thing
% [p_1,p_2,n_1,n_2,Xi_1,Xi_2,w1,IEN,C,n_el,w_pre,P_post1,P_post2,P1,P2,Xi_1Parent,Xi_2Parent] = multipatch_test_geom();
% 
% P_post = cat(3,P_post1,P_post2);
% w = cat(3,w1,w1);
% w_pre = cat(2,w_pre,w_pre);
% C = cat(3,C,C);
% 
% IEN = [IEN,IEN+20];
% 
% n_1_new = length(Xi_1) - (p_1 + 1);
% n_2_new = length(Xi_2) - (p_2 + 1);
% 
% [d] = Heat_Conduction_multi(p_1,n_1_new,n_2_new,Xi_1Parent,Xi_2Parent,P_post,w,n_q,IEN,C,n_el,w_pre,w_quad,quad_p);
% 
% plot_patches(p_1,p_2,n_1,n_2,Xi_1Parent,Xi_2Parent,P_post,w,d,IEN);



