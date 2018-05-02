function [k_e,f_e,n_loc] = Element_Formation(e,nq,Xi_q,C,P,w_be,w_e,w_q,Neumann,Robin,k,f,h,beta,U_R,p,Xi_1,Xi_2,IEN)
k_e = zeros(nq^2);
f_e = zeros(nq^2,1);
n_loc = nq^2;
%% Loop over element interiors
for q1 = 1:nq
    for q2 = 1:nq
        [Ra,dRa_dx,dRa_dy,~,J] = Shape_function(e,Xi_q(q1),Xi_q(q2),n_loc,p,Xi_1,Xi_2,w_be,w_e,C,P,IEN);
        j = det(J);
        k_loc = k;  % heat conduction coefficient
        f_loc = f;  % heat generated
        for a = 1:n_loc
            for b = 1:n_loc
                k_e(a,b) = k_e(a,b) + k_loc*(dRa_dx(a)*dRa_dx(b) + dRa_dy(a)*dRa_dy(b))*w_q(q1)*w_q(q2)*j;
            end
            f_e(a) = f_e(a) + Ra(a)*f_loc*w_q(q1)*w_q(q2)*j;
        end
    end
end

%% Loop over Element Boundaries
for side = 1:4  % since we are only in 2D
    if Neumann(side,e) == 1 || Robin(side,e) == 1
        for q = 1:nq
            switch side
                case 1
                    xi_1 = Xi_q(q);
                    xi_2 = 0;
                    t_tilde = [1;0];
                case 2
                    xi_1 = 1;
                    xi_2 = Xi_q(q);
                    t_tilde = [0;1];
                case 3
                    xi_1 = Xi_q(q);
                    xi_2 = 1;
                    t_tilde = [1;0];
                case 4
                    xi_1 = 0;
                    xi_2 = Xi_q(q);
                    t_tilde = [0;1];
            end
            [Ra,~,~,~,J] = Shape_function(e,xi_1,xi_2,n_loc,p,Xi_1,Xi_2,w_be,w_e,C,P,IEN);
            j_gamma = norm(J*t_tilde);
            
            % neumann boundary
            if Neumann(side,e) == 1
                h_loc = h;  % convection coefficient
                for a = 1:n_loc
                    f_e(a) = f_e(a) + Ra(a)*h_loc*w_q(q)*j_gamma;
                end
            end
            % Robin boundary
            if Robin(side,e) == 1
                beta_loc = beta;
                U_R_loc = U_R;   % temperature at this edge's surface, this is temp of the medium
                for a = 1:n_loc
                    for b = 1:n_loc
                        k_e(a,b) = k_e(a,b) + beta_loc*Ra(a)*Ra(b)*w_q(q)*j_gamma;
                    end
                    f_e(a) = f_e(a) + beta_loc*Ra(a)*U_R_loc*w_q(q)*j_gamma;
                end
            end
        end
    end
    
    
end