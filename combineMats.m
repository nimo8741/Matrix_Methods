function [P_post,w,w_pre,C] = combineMats(P_post1,P_post2,P_post3,P_post4,P_post5,w_pre_s,w_pre,w1,w2,C)
%% first go through and combine all of the control points

P_post = cat(3,P_post1,P_post2,P_post3,P_post4,P_post5);

%% now concatenate the pre extraction weights

w = cat(3,w1,w2,w2,w2,w2);

w_pre = cat(3,w_pre_s,w_pre,w_pre,w_pre,w_pre);

C = cat(3,C,C,C,C,C);


end
