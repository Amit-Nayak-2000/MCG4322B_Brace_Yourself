% Symbolic Constants (variable names) for Superior Link
syms F_fs F_t F_spy F_spx F_sax F_say F_sp F_n r_s_cp r_s_ct r_s_ca
syms r_s_ca r_s_ct r_s_cp I_s alpha_s alpha_s_z a_sx a_sy T_s1 m_s theta_1 g
syms r_s_cp_x r_s_cp_y r_s_ct_x r_s_ct_y r_s_ca_x r_s_ca_y T_s_e1 T_s_1

%Reaction forces with posterior link
F_sp = [F_spx; F_spy; 0];
%Reaction forces with anteror link
F_sa = [F_sax; F_say; 0];
%Normal forces of thigh pushing the strap
%Note! The sign convention is from trig identities.
F_t = [F_n*cos(theta_1) - F_fs*sin(theta_1); F_n*sin(theta_1) + F_fs*cos(theta_1); 0];
%Linear Acceleration of superior link
a_s = [a_sx; a_sy; 0];
%Angular Acceleration of superior link
alpha_s = [0; 0; alpha_s];
%Gravity
g = [0; -9.81; 0];
%Moment arm for posterior link WRT superior link COM
r_s_cp = [r_s_cp_x; r_s_cp_y; 0];
%Moment arm for thigh WRT superior link COM
r_s_ct = [r_s_ct_x; r_s_ct_y; 0];
%Moment arm for anterior link WRT superior link COM
r_s_ca = [r_s_ca_x; r_s_ca_y; 0];
%Torque from spring 1
T_s_e1 = [0; 0; T_s_1];

% 1 = x, 2 = y, 3 = z
%Sum of forces in x (superior link)
sup_link_x = F_sp(1) + F_sa(1) + F_t(1) == m_s*a_s(1);
%Sum of forces in y (superior link)
sup_link_y = F_sp(2) + F_sa(2) + m_s*g(2) + F_t(2) == m_s*a_s(2);
%Sum of moments in z (superior link)
sup_link_z = cross(r_s_cp, F_sp) + cross(r_s_ca, F_sa) + cross(r_s_ct, F_t) + T_s_e1 == I_s*alpha_s(3);







