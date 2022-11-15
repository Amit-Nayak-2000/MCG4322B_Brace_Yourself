function [] = StressCalculations(S, I, A, P, TorsionalSpring, VT, VC)
% calculates stresses related to S link
% inputs: ( , )
% output: [ , , , , ]

% description

%% Symbolic Variables
% constants
g = 9.81;

%% Superior Link

% SYMBOLS
% longitudinal forces
syms F_tt F_tn F_scomxlong F_scomylong F_saxlong F_saylong
syms F_spxlong F_spylong F_sspring1
% stresses
syms sigma_sx sigma_s1y sigma_s2y sigma_s3y sigma_sbend1 sigma_sbend2
syms tau_s1 tau_s2 tau_s3 sigma_srupture moment_s1 moment_s2
% safety factors
syms SF_sigma_sx SF_sigma_s1y SF_sigma_s2y SF_sigma_s3y SF_sigma_sbend1 SF_sigma_sbend2
syms SF_sigma_srupture SF_tau_s1 SF_tau_s2 SF_tau_s3

% LONGITUDINAL FORCE CALCULATIONS
F_tt = -S.F_t(1)*sind(S.theta) + S.F_t(2)*cosd(S.theta);
F_tn = S.F_t(1)*cosd(S.theta) + S.F_t(2)*sind(S.theta);
F_scomxlong = S.m*S.a(1)*cosd(S.theta) + S.m*S.a(2)*sind(S.theta) - S.m*g*sind(S.theta); 
F_scomylong = -S.m*S.a(1)*sind(S.theta) + S.m*S.a(2)*cosd(S.theta) - S.m*g*cosd(S.theta);
F_saxlong = S.F_sa(1)*cosd(S.theta) + S.F_sa(2)*sind(S.theta);
F_saylong = -S.F_sa(1)*sind(S.theta) + S.F_sa(2)*cosd(S.theta);
F_spxlong = S.F_sp(1)*cosd(S.theta) + S.F_sp(2)*sind(S.theta);
F_spylong = -S.F_sp(1)*sind(S.theta) + S.F_sp(2)*cosd(S.theta);
F_sspring1 = -TorsionalSpring.Torque(3)*0.4*S.L;

% STRESS CALCULATIONS
% along x long
if abs(F_tn) > abs(F_scomxlong + F_saxlong + F_spxlong)
    sigma_sx = F_tn/((S.H4-S.H3)*S.T);
else
    sigma_sx = (F_scomxlong + F_saxlong + F_spxlong)/((S.H4-S.H3)*S.T);
end

% along y long and rupture
if abs(F_tt + F_scomylong) > abs(F_saylong + F_spylong + F_sspring1)
    sigma_s1y = (F_tt + F_scomylong)/(S.B1*S.T);
    sigma_srupture = (F_tt + F_scomylong)/(S.B1*S.T); % need to subtract 2*Bearing.D*S.T from area
else
    sigma_s1y = (F_saylong + F_spylong + F_sspring1)/(S.B1*S.T);
    sigma_srupture = (F_saylong + F_spylong + F_sspring1)/(S.B1*S.T); % need to subtract 2*Bearing.D*S.T from area
end

if abs(F_tt) > abs(F_scomylong + F_saylong + F_spylong + F_sspring1)
    sigma_s2y = F_tt / (S.B2*S.T);
    sigma_s3y = F_tt / (S.B3*S.T);
else
    sigma_s2y = (F_scomylong + F_saylong + F_spylong + F_sspring1) / (S.B2*S.T);
    sigma_s3y = (F_scomylong + F_saylong + F_spylong + F_sspring1) / (S.B3*S.T);
end

% bending
moment_s1 = S.I*S.alpha(3) + (S.B3/2)*F_tt - (S.B3/2 - S.B2/2)*(F_scomylong + F_saylong + F_spylong + F_sspring1);
moment_s2 = S.I*S.alpha(3) - (S.L/2)*F_saylong - (S.H4 - S.com(2) - S.H1/2)*F_saxlong - (S.L/2)*F_spylong + (S.H4 - S.com(2) - S.H1/2)*F_spxlong + ((S.L/2)-0.4*S.L)*F_sspring1 - S.com(2)*F_tn;

sigma_sbend1 = -moment_s1*((S.H4-S.H3)/2) / ((S.B3*(S.H4-S.H3)^3)/12);
%sigma_ibend2 = -moment_s2 * ?y? / ?I?

% shear
if abs(F_tn + F_scomxlong) > abs(F_saxlong + F_spxlong)
    tau_s1 = (F_tn + F_scomxlong)/(S.B1*S.T);
else
    tau_s1 = (F_saxlong + F_spxlong)/(S.B1*S.T);
end

if abs(F_tn) > abs(F_scomxlong + F_saxlong + F_spxlong)
    tau_s2 = (F_tn)/(S.B2*S.T);
    tau_s3 = (F_tn)/(S.B3*S.T);
else
    tau_s2 = (F_scomxlong + F_saxlong + F_spxlong)/(S.B2*S.T);
    tau_s3 = (F_scomxlong + F_saxlong + F_spxlong)/(S.B3*S.T);
end

% SAFETY FACTOR CALCULATIONS
SF_sigma_sx = sigma_sx/S.E;
SF_sigma_s1y = sigma_s1y/S.E;
SF_sigma_s2y = sigma_s2y/S.E;
SF_sigma_s3y = sigma_s3y/S.E;
SF_sigma_sbend1 = sigma_sbend1/S.E;
SF_sigma_sbend2 = sigma_sbend2/S.E;
SF_sigma_srupture = sigma_srupture/S.E;
SF_tau_s1 = tau_s1/S.G;
SF_tau_s2 = tau_s2/S.G;
SF_tau_s3 = tau_s3/S.G;

%% Inferior Link

% Symbols
% longitudinal forces
syms F_ct F_cn F_icomxlong F_icomylong F_iaxlong F_iaylong
syms F_ipxlong F_ipylong F_spring2

% stresses
syms sigma_ix sigma_i1y sigma_i2y sigma_i3y sigma_ibend1 sigma_ibend2
syms tau_i1 tau_i2 tau_i3 sigma_irupture moment_i1 moment_i2 

% safety factors
syms SF_sigma_ix SF_sigma_i1y SF_sigma_i2y SF_sigma_i3y SF_sigma_ibend1 SF_sigma_ibend2
syms SF_tau_i1 SF_tau_i2 SF_tau_i3 SF_sigma_irupture 

% longitudinal force calculations
F_ct = -I.F_c(1)*sind(I.theta) + I.F_c(2)*cosd(I.theta);
F_cn = I.F_c(1)*cosd(I.theta) + I.F_c(2)*sind(I.theta);
F_icomxlong = I.m*I.a(1)*cosd(I.theta) + I.m*I.a(2)*sind(I.theta) - I.m*g*sind(I.theta); 
F_icomylong = -I.m*I.a(1)*sind(I.theta) + I.m*I.a(2)*cosd(I.theta) - I.m*g*cosd(I.theta);
F_iaxlong = I.F_ia(1)*cosd(I.theta) + I.F_ia(2)*sind(I.theta);
F_iaylong = -I.F_ia(1)*sind(I.theta) + I.F_ia(2)*cosd(I.theta);
F_ipxlong = I.F_ip(1)*cosd(I.theta) + I.F_ip(2)*sind(I.theta);
F_ipylong = -I.F_ip(1)*sind(I.theta) + I.F_isp(2)*cosd(I.theta);
F_spring2 = -TorsionalSpring.Torque(3)*0.4*I.L;

% Stress Calculations
% along x long
if abs(F_cn)>abs(F_icomxlong + F_iaxlong + F_ipxlong)
    sigma_ix = F_cn/((I.H4-I.H3)*I.T);
else
    sigma_ix = (F_icomxlong + F_iaxlong + F_ipxlong)/((I.H4-I.H3)*I.T);
end

% along y long
if abs(F_ct + F_icomylong)>abs(F_iaylong + F_ipylong + F_spring2)
    sigma_i1y = (F_ct + F_icomylong)/(I.B1*I.T);
    %add rupture sigma_irupture = 
else
    sigma_i1y = (F_iaylong + F_ipylong + F_spring2)/(I.B1*I.T);
    %add rupture sigma_irupture = 
end

if abs(F_ct)>abs(F_icomylong + F_iaylong + F_ipylong + F_spring2)
    sigma_i2y = F_ct / (I.B2*I.T);
    sigma_i3y = F_ct / (I.B3*I.T);
else
    sigma_i2y = (F_icomylong + F_iaylong + F_ipylong + F_spring2) / (I.B2*I.T);
    sigma_i3y = (F_icomylong + F_iaylong + F_ipylong + F_spring2) / (I.B3*I.T);
end

% bending
moment_i1 = I.I*I.alpha(3) + (I.B3/2)*F_ct - (I.B3/2 - I.B2/2)*(F_icomylong + F_iaylong + F_ipylong + F_spring2);
moment_i2 = I.I*I.alpha(3) - (I.L/2)*F_iaylong - (I.H4 - I.com(2) - I.H1/2)*F_iaxlong + (I.L/2)*F_ipylong - (I.H4 - I.com(2) - I.H1/2)*F_ipxlong + ((I.L/2)-0.4*I.L)*F_spring2 + I.com(2)*F_cn;

sigma_ibend1 = -moment_i1*((I.H4-I.H3)/2) / ((I.B3*(I.H4-I.H3)^3)/12);
sigma_ibend2 = %idk what y and I is for this shape

% shear
if abs(F_cn + F_icomxlong) > abs(F_iaxlong + F_ipxlong)
    tau_i1 = (F_cn + F_icomxlong)/(I.B1*I.T);
else
    tau_i1 = (F_iaxlong + F_ipxlong)/(I.B1*I.T);
end

if abs(F_cn) > abs(F_icomxlong + F_iaxlong + F_ipxlong)
    tau_i2 = (F_cn)/(I.B2*I.T);
    tau_i3 = (F_cn)/(I.B3*I.T);
else
    tau_i2 = (F_icomxlong + F_iaxlong + F_ipxlong)/(I.B2*I.T);
    tau_i3 = (F_icomxlong + F_iaxlong + F_ipxlong)/(I.B3*I.T);
end

% Safety Factors
SF_sigma_ix = sigma_ix/I.E;
SF_sigma_i1y = sigma_i1y/I.E;
SF_sigma_i2y = sigma_i2y/I.E;
SF_sigma_i3y = sigma_i3y/I.E;
SF_sigma_ibend1 = sigma_ibend1/I.E;
SF_sigma_ibend2 = sigma_ibend2/I.E;
SF_sigma_irupture = sigma_irupture/I.E;
SF_tau_i1 = tau_i1/I.G;
SF_tau_i2 = tau_i2/I.G;
SF_tau_i3 = tau_i3/I.G;

%% Anterior Link

% SYMBOLS
% longitudinal forces
syms F_acomxlong F_acomylong F_asxlong F_asylong F_aixlong F_aiylong F_aspring1 moment_a

% stresses
syms sigma_a1y sigma_a2y sigma_abend tau_a1 tau_a2 sigma_arupture1 sigma_arupture2

% safety factors
syms SF_sigma_a1y SF_sigma_a2y SF_sigma_abend SF_tau_a1 SF_tau_a2 SF_sigma_arupture1 SF_sigma_arupture2

% LONGITUDINAL FORCE CALCULATIONS
F_acomxlong = -A.m*A.a(1)*sind(A.theta) + A.m*A.a(2)*cosd(A.theta) - A.m*g*cosd(A.theta);
F_acomylong = -A.m*A.a(1)*cosd(A.theta) - A.m*A.a(2)*sind(A.theta) + A.m*g*sind(A.theta);
F_asxlong = -A.F_sa(1)*sind(A.theta) + A.F_sa(2)*cosd(A.theta);
F_asylong = -A.F_sa(1)*cosd(A.theta) - A.F_sa(2)*sind(A.theta);
F_aixlong = -A.F_ia(1)*sind(A.theta) + A.F_ia(2)*cosd(A.theta);
F_aiylong = -A.F_ia(1)*cosd(A.theta) - A.F_ia(2)*sind(A.theta);
F_aspring1 = -1*F_sspring1;

% STRESS CALCULATIONS
% along y long and rupture
if abs(F_asylong) > abs(F_acomylong + F_aiylong)
    sigma_a1y = (F_asylong)/(A.B*A.T);
    sigma_arupture1 = (F_asylong)/(A.B*A.T);
    % need to subtract Bearing.D*A.T from area
else
    sigma_a1y = (F_acomylong + F_aiylong)/(A.B*A.T);
    sigma_arupture1 = (F_acomylong + F_aiylong)/(A.B*A.T);
    % need to subtract Bearing.D*A.T from area
end

if abs(F_asylong + F_acomylong) > abs(F_aiylong)
    sigma_a2y = (F_asylong + F_acomylong)/(A.B*A.T);
    sigma_arupture2 = (F_asylong + F_acomylong)/(A.B*A.T);
    % need to subtract Bearing.D*A.T from area
else
    sigma_a2y = (F_aiylong)/(A.B*A.T);
    sigma_arupture2 = (F_aiylong)/(A.B*A.T);
    % need to subtract Bearing.D*A.T from area
end

% bending
moment_a = -(A.L/2)*F_asxlong - (A.L/2-0.4*S.L)*F_aspring1 + (A.L/2)*F_aixlong + A.I*alpha(3);
sigma_abend = -moment_a * (A.L/2) / A.I;

% shear
if abs(F_asxlong) > abs(F_acomxlong + F_aixlong)
    tau_a1 = (F_asxlong)/(A.B*A.T);
else
    tau_a1 = (F_acomxlong + F_aixlong)/(A.B*A.T);
end

if abs(F_asxlong + F_acomxlong) > abs(F_aixlong)
    tau_a2 = (F_asxlong + F_acomxlong)/(A.B*A.T);
else
    tau_a2 = (F_aixlong)/(A.B*A.T);
end

% SAFETY FACTOR CALCULATIONS
SF_sigma_a1y = sigma_a1y/A.E;
SF_sigma_a2y = sigma_a2y/A.E;
SF_sigma_abend = sigma_abend/A.E;
SF_sigma_arupture1 = sigma_arupture1/A.E;
SF_sigma_arupture2 = sigma_arupture2/A.E;
SF_tau_a1 = tau_a1/A.G;
SF_tau_a2 = tau_a2/A.G;

%% Posterior Link

% longitudinal forces
syms F_pcomxlong F_pcomylong F_psxlong F_psylong F_pixlong F_piylong F_pspring2 moment_p

% stresses
syms sigma_p1y sigma_p2y sigma_pbend tau_p1 tau_p2 sigma_prupture1 sigma_prupture2

% longitudinal force calculations
F_pcomxlong = P.m*P.a(1)*sind(P.theta) - P.m*P.a(2)*cosd(P.theta) + P.m*g*cosd(P.theta);
F_pcomylong = P.m*P.a(1)*cosd(P.theta) + P.m*P.a(2)*sind(P.theta) - P.m*g*sind(P.theta);
F_psxlong = P.F_sp(1)*sind(P.theta) - P.F_sp(2)*cosd(P.theta);
F_psylong = P.F_sp(1)*cosd(P.theta) + P.F_sp(2)*sind(P.theta);
F_pixlong = P.F_ip(1)*sind(P.theta) - P.F_ip(2)*cosd(P.theta);
F_piylong = P.F_ip(1)*cosd(P.theta) + P.F_ip(2)*sind(P.theta);
F_pspring2 = -1*F_spring2; %F_pspring2

% stress calculations
% along y long and rupture
if abs(F_psylong) > abs(F_pcomylong + F_piylong)
    sigma_p1y = (F_psylong)/(P.B*P.T);
    sigma_prupture1 = (F_psylong)/(P.B*P.T);
    % need to subtract Bearing.D*P.T from area
else
    sigma_p1y = (F_pcomylong + F_piylong)/(P.B*P.T);
    sigma_prupture1 = (F_pcomylong + F_piylong)/(P.B*P.T);
    % need to subtract Bearing.D*P.T from area
end

if abs(F_psylong + F_pcomylong) > abs(F_piylong)
    sigma_p2y = (F_psylong + F_pcomylong)/(P.B*P.T);
    sigma_prupture2 = (F_psylong + F_pcomylong)/(P.B*P.T);
    % need to subtract Bearing.D*P.T from area
else
    sigma_p2y = (F_piylong)/(P.B*P.T);
    sigma_prupture2 = (F_piylong)/(P.B*P.T);
    % need to subtract Bearing.D*P.T from area
end

% bending
moment_p = -(P.L/2)*F_psxlong + (P.L/2-0.4*I.L)*F_pspring2 + (P.L/2)*F_pixlong + P.I*alpha(3);
sigma_pbend = -moment_p * (P.L/2) / P.I;

% shear
if abs(F_psxlong) > abs(F_pcomxlong + F_pixlong)
    tau_p1 = (F_psxlong)/(P.B*P.T);
else
    tau_p1 = (F_pcomxlong + F_pixlong)/(P.B*P.T);
end

if abs(F_psxlong + F_pcomxlong) > abs(F_pixlong)
    tau_p2 = (F_psxlong + F_pcomxlong)/(P.B*P.T);
else
    tau_p2 = (F_pixlong)/(P.B*P.T);
end

% Safety Factors


%% Velcro
% SYMBOLS
syms tau_vt tau_vc
syms SF_tau_vt SF_tau_vc

% STRESS CALCULATIONS
tau_vt = F_tn / (VT.L * VT.W);
tau_vc = F_cn / (VC.L * VC.W);

% SAFETY FACTOR CALCULATIONS
SF_tau_vt = VT.G/tau_vt;
SF_tau_vc = VC.G/tau_vc;

%% Springs




%% Bolts
syms tau_sa tau_sp tau_ia tau_ip
syms SF_shearsa SF_shearsp SF_shearia SF_shearip

% Stress Calculations
tau_sa = (4*norm(Superior.F_sa))/pi*Bolt.d; %NEED to create bolt object, d for diameter
tau_sp = (4*norm(Superior.F_sp))/pi*Bolt.d;
tau_ia = (4*norm(Superior.F_ia))/pi*Bolt.d;
tau_ip = (4*norm(Superior.F_ip))/pi*Bolt.d;

%Safety Factor
SF_shearsa = tau_sa/Bolt.E; %NEED to define bolt mod in bolt object
SF_shearsp = tau_sp/Bolt.E; 
SF_shearia = tau_ia/Bolt.E; 
SF_shearip = tau_ip/Bolt.E; 




%% Bearings




%% return or modifying object values
% we will figure this out soon




end

