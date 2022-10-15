function [] = Kinetic_Saggital(Superior,Inferior,Posterior,Anterior)
%KINETIC MODELLING SAGGITAL PLANE
%Inputs: Link objects
%Output: Updated force attributes within objects.

%This function uses newtonian mechanics to solve for forces on the links.
%The torsional spring torque is calculated by hook's law. 

%Knowns: Masses, Moments of Inertia, Kinematics.
%Unknowns: Reaction Forces between links, Forces between body and brace.

%Process: 
%Construct F = ma for x & y axis and T = I*alpha for z axis for each link. 
%Combine all the equations of motion and solve for unknowns. 
%Symbolic variables will be assigned to unknowns initially. 
%% Symbolic Variables
syms F_t F_spy F_spx F_sax F_say F_sp F_sa F_fc F_c
syms F_ipx F_ipy F_ia F_iax F_iay F_tn F_ft F_cn 

%Gravity vector
g = [0; -9.81; 0];
%TODO: finish torques.
Torque1 = [0;0;10];
Torque2 = [0;0;-20];
%% Unknown Force Vectors
%Reaction force between Superior and Posterior links.
F_sp = [F_spx; F_spy; 0];
%Reaction force between Superior and Anterior links.
F_sa = [F_sax; F_say; 0];
%Reaction force between Interior and Posterior links.
F_ip = [F_ipx; F_ipy; 0];
%Reaction force between Interior and Anterior links.
F_ia = [F_iax; F_iay; 0];
%Force between brace and thigh.
%Note! The sign convention is from trig identities.
F_t = [F_tn*cosd(Superior.theta(3)) - F_ft*sind(Superior.theta(3)); F_tn*sind(Superior.theta(3)) + F_ft*cosd(Superior.theta(3)); 0];
%Force between brace and calf.
%Note! The sign convention is from trig identities.
F_c = [F_cn*cosd(Inferior.theta(3)) - F_fc*sind(Inferior.theta(3)); F_cn*sind(Inferior.theta(3)) + F_fc*cosd(Inferior.theta(3)); 0];

%12 equations & 12 unknowns.
%% Superior Link
%Sum of forces in x:
Sup_x = F_sp(1) + F_sa(1) + F_t(1) == Superior.m*Superior.a(1);
%Sum of forces in y:
Sup_y = F_sp(2) + F_sa(2) + Superior.m*g(2) + F_t(2) == Superior.m*Superior.a(2);
%Sum of moments about z:
Sup_z = cross(Superior.rsp, F_sp) + cross(Superior.rsa, F_sa) + cross(Superior.rst, F_t) + Torque1(3) == Superior.I*Superior.alpha(3);

%% Anterior Link
%Sum of forces in x:
Ant_x = -F_sa(1) - F_ia(1) == Anterior.m*Anterior.a(1);
%Sum of forces in y:
Ant_y = -F_sa(2) - F_ia(2) + Anterior.m*g(2) == Anterior.m*Anterior.a(2);
%Sum of moments about z:
Ant_z = cross(Anterior.rsa, -F_sa) + cross(Anterior.ria, -F_ia) - Torque1(3) == Anterior.I*Anterior.alpha(3);

%% Posterior Link
%Sum of forces in x:
Pos_x = -F_sp(1) - F_ip(1) == Posterior.m*Posterior.a(1);
%Sum of forces in y:
Pos_y = -F_sp(2) - F_ip(2) + Posterior.m*g(2) == Posterior.m*Posterior.a(2);
%Sum of moments about z:
Pos_z = cross(Posterior.rsp, -F_sp) + cross(Posterior.rip, -F_ip) - Torque2(3) == Posterior.I*Posterior.alpha(3);

%% Inferior Link
%Sum of forces in x:
Inf_x = F_ip(1) + F_ia(1) + F_c(1) == Inferior.m*Inferior.a(1);
%Sum of forces in y:
Inf_y = F_ip(2) + F_ia(2) + Inferior.m*g(2) + F_c(2) == Inferior.m*Inferior.a(2);
%Sum of moments about z:
Inf_z = cross(Inferior.rip, F_ip) + cross(Inferior.ria, F_ia) + cross(Superior.ric, F_c) + Torque2(3) == Inferior.I*Inferior.alpha(3);
%% Solve system of equations
syseqns = [Sup_x, Sup_y, Sup_z, Ant_x, Ant_y, Ant_z, Pos_x, Pos_y, Pos_z, Inf_x, Inf_y, Inf_z];

end

