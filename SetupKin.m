function [] = SetupKin()
%% Symbolic Variables
syms F_t F_spy F_spx F_sax F_say F_sp F_sa F_fc F_c
syms F_ipx F_ipy F_ia F_iax F_iay F_tn F_ft F_cn 
syms ST AT PT IT SAl AAl PAl IAl SA AA PA IA SM AM PM IM SI II AI PI
syms SRSP SRSA IRIP IRIA ARIA ARSA PRIP PRSP
g = [0; -9.81; 0];
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
F_t = [F_tn*cosd(ST) - F_ft*sind(ST); F_tn*sind(ST) + F_ft*cosd(ST); 0];
%Force between brace and calf.
%Note! The sign convention is from trig identities.
F_c = [F_cn*cosd(IT) - F_fc*sind(IT); F_cn*sind(IT) + F_fc*cosd(IT); 0];

SA = sym('SA', [3 1]);
SAL = sym('SAL', [3 1]);
SRSP = sym('SRSP', [3 1]);
SRSA = sym('SRSA', [3 1]);
SRST = sym('SRST', [3 1]);
Torque1 = sym('T1', [3 1]);

%12 equations & 12 unknowns.
%% Superior Link
%Sum of forces in x:
Sup_x = F_sp(1) + F_sa(1) + F_t(1) == SM*SA(1);
%Sum of forces in y:
Sup_y = F_sp(2) + F_sa(2) + SM*g(2) + F_t(2) == SM*SA(2);
%Sum of moments about z:
Sup_z = cross(SRSP, F_sp) + cross(SRSA, F_sa) + cross(SRST, F_t) + Torque1 == SI*SAL;

%% Anterior Link

AA = sym('AA', [3 1]);
AAL = sym('AAL', [3 1]);
ARSA = sym('ARSA', [3 1]);
ARIA = sym('ARIA', [3 1]);

%Sum of forces in x:
Ant_x = -F_sa(1) - F_ia(1) == AM*AA(1);
%Sum of forces in y:
Ant_y = -F_sa(2) - F_ia(2) + AM*g(2) == AM*AA(2);
%Sum of moments about z:
%Anterior.rsa and Anterior.ria are negative because they were originally
%defined as from the joint to the centre of mass. For this we need from the
%centre of the mass to the joint.
Ant_z = cross(-ARSA, -F_sa) + cross(-ARIA, -F_ia) - Torque1 == AI*AAL;

%% Posterior Link
PA = sym('PA', [3 1]);
PAL = sym('PAL', [3 1]);
PRSP = sym('PRSP', [3 1]);
PRIP = sym('PRIP', [3 1]);
Torque2 = sym('T2', [3 1]);


%Sum of forces in x:
Pos_x = -F_sp(1) - F_ip(1) == PM*PA(1);
%Sum of forces in y:
Pos_y = -F_sp(2) - F_ip(2) + PM*g(2) == PM*PA(2);
%Sum of moments about z:
%Posterior.rsp and Posterior.rip are negative because they were originally
%defined as from the joint to the centre of mass. For this we need from the
%centre of the mass to the joint.
Pos_z = cross(-PRSP, -F_sp) + cross(-PRIP, -F_ip) - Torque2 == PI*PAL;

%% Inferior Link
IA = sym('IA', [3 1]);
IAL = sym('IAL', [3 1]);
IRIP = sym('IRIP', [3 1]);
IRIA = sym('IRIA', [3 1]);
IRIC = sym('IRIC', [3 1]);



%Sum of forces in x:
Inf_x = F_ip(1) + F_ia(1) + F_c(1) == IM*IA(1);
%Sum of forces in y:
Inf_y = F_ip(2) + F_ia(2) + IM*g(2) + F_c(2) == IM*IA(2);
%Sum of moments about z:
Inf_z = cross(IRIP, F_ip) + cross(IRIA, F_ia) + cross(IRIC, F_c) + Torque2 == II*IAL;
%% Solve system of equations
syseqns = [Sup_x, Sup_y, Sup_z(3), Ant_x, Ant_y, Ant_z(3), Pos_x, Pos_y, Pos_z(3), Inf_x, Inf_y, Inf_z(3)];
sol = solve(syseqns, [F_spx, F_spy, F_ipx, F_ipy, F_sax, F_say, F_iax, F_iay, F_tn, F_ft, F_cn, F_fc]);

%assign values to superior link
Superior.F_sp(1) = double(sol.F_spx);
Superior.F_sp(2) = double(sol.F_spy);

Superior.F_sa(1) = double(sol.F_sax);
Superior.F_sa(2) = double(sol.F_say);

Superior.F_t(1) = double(sol.F_tn)*cosd(Superior.theta) - double(sol.F_ft)*sind(Superior.theta);
Superior.F_t(2) = double(sol.F_tn)*sind(Superior.theta) + double(sol.F_ft)*cosd(Superior.theta);

Superior.F_tn = double(sol.F_tn);
Superior.F_tt = double(sol.F_ft);

%assign values to anterior link
%on anterior and posterior links, the reaction forces are defined as equal
%and opposite to the superior and inferior links.
Anterior.F_sa(1) = -double(sol.F_sax);
Anterior.F_sa(2) = -double(sol.F_say);

Anterior.F_ia(1) = -double(sol.F_iax);
Anterior.F_ia(2) = -double(sol.F_iay);

%assign values to posterior link
Posterior.F_sp(1) = -double(sol.F_spx);
Posterior.F_sp(2) = -double(sol.F_spy);

Posterior.F_ip(1) = -double(sol.F_ipx);
Posterior.F_ip(2) = -double(sol.F_ipy);

%assign values to inferior link
Inferior.F_ip(1) = double(sol.F_ipx);
Inferior.F_ip(2) = double(sol.F_ipy);

Inferior.F_ia(1) = double(sol.F_iax);
Inferior.F_ia(2) = double(sol.F_iay);

Inferior.F_c(1) = double(sol.F_cn)*cosd(Inferior.theta) - double(sol.F_fc)*sind(Inferior.theta);
Inferior.F_c(2) = double(sol.F_cn)*sind(Inferior.theta) + double(sol.F_fc)*cosd(Inferior.theta);

Inferior.F_cn = double(sol.F_cn);
Inferior.F_ct = double(sol.F_fc);














end

