function [] = StressCalculations(Superior, Inferior, Anterior, Posterior, TorsionalSpring)
% calculates stresses related to superior link
% inputs: ( , )
% output: [ , , , , ]

% description

%% Symbolic Variables
% constants
g = 9.81;
%E = 

%% Superior Link

% Symbols
% longitudinal forces
syms F_tt F_tn F_scomxlong F_scomylong F_saxlong F_saylong
syms F_spxlong F_spylong F_spring1

% stresses
syms sigma_sx sigma_s1y sigma_s2y sigma_s3y sigma_sbend1 sigma_sbend2
syms tau_s1 tau_s2 tau_s3 sigma_srupture moment_s1 moment_s2

% longitudinal force calculations
F_tt = -Superior.F_t(1)*sind(Superior.theta) + Superior.F_t(2)*cosd(Superior.theta);
F_tn = Superior.F_t(1)*cosd(Superior.theta) + Superior.F_t(2)*sind(Superior.theta);
F_scomxlong = Superior.m*Superior.a(1)*cosd(Superior.theta) + Superior.m*Superior.a(2)*sind(Superior.theta) - Superior.m*g*sind(Superior.theta); 
F_scomylong = -Superior.m*Superior.a(1)*sind(Superior.theta) + Superior.m*Superior.a(2)*cosd(Superior.theta) - Superior.m*g*cosd(Superior.theta);
F_saxlong = Superior.F_sa(1)*cosd(Superior.theta) + Superior.F_sa(2)*sind(Superior.theta);
F_saylong = -Superior.F_sa(1)*sind(Superior.theta) + Superior.F_sa(2)*cosd(Superior.theta);
F_spxlong = Superior.F_sp(1)*cosd(Superior.theta) + Superior.F_sp(2)*sind(Superior.theta);
F_spylong = -Superior.F_sp(1)*sind(Superior.theta) + Superior.F_sp(2)*cosd(Superior.theta);
F_spring1 = -TorsionalSpring.Torque(3)*0.4*Superior.L;

% stress calculations
% along x long
if abs(F_tn) > abs(F_scomxlong + F_saxlong + F_spxlong)
    sigma_sx = F_tn/((Superior.H4-Superior.H3)*Superior.T);
else
    sigma_sx = (F_scomxlong + F_saxlong + F_spxlong)/((Superior.H4-Superior.H3)*Superior.T);
end

% along y long and rupture
if abs(F_tt + F_scomylong) > abs(F_saylong + F_spylong + F_spring1)
    sigma_s1y = (F_tt + F_scomylong)/(Superior.B1*Superior.T);
    sigma_srupture = (F_tt + F_scomylong)/(Superior.B1*Superior.T); % need to subtract 2*Bearing.D*Superior.T from area
else
    sigma_s1y = (F_saylong + F_spylong + F_spring1)/(Superior.B1*Superior.T);
    sigma_srupture = (F_saylong + F_spylong + F_spring1)/(Superior.B1*Superior.T); % need to subtract 2*Bearing.D*Superior.T from area
end

if abs(F_tt) > abs(F_scomylong + F_saylong + F_spylong + F_spring1)
    sigma_s2y = F_tt / (Superior.B2*Superior.T);
    sigma_s3y = F_tt / (Superior.B3*Superior.T);
else
    sigma_s2y = (F_scomylong + F_saylong + F_spylong + F_spring1) / (Superior.B2*Superior.T);
    sigma_s3y = (F_scomylong + F_saylong + F_spylong + F_spring1) / (Superior.B3*Superior.T);
end

% bending
moment_s1 = Superior.I*Superior.alpha(3) + (Superior.B3/2)*F_tt - (Superior.B3/2 - Superior.B2/2)*(F_scomylong + F_saylong + F_spylong + F_spring1);
moment_s2 = Superior.I*Superior.alpha(3) - (Superior.L/2)*F_saylong - (Superior.H4 - Superior.com(2) - Superior.H1/2)*F_saxlong - (Superior.L/2)*F_spylong + (Superior.H4 - Superior.com(2) - Superior.H1/2)*F_spxlong + ((Superior.L/2)-0.4*Superior.L)*F_spring1 - Superior.com(2)*F_tn;

sigma_sbend1 = -moment_s1*((Superior.H4-Superior.H3)/2) / ((Superior.B3*(Superior.H4-Superior.H3)^3)/12);
%sigma_ibend2 = -moment_s2 * ?y? / ?I?

% shear
if abs(F_tn + F_scomxlong) > abs(F_saxlong + F_spxlong)
    tau_s1 = (F_tn + F_scomxlong)/(Superior.B1*Superior.T);
else
    tau_s1 = (F_saxlong + F_spxlong)/(Superior.B1*Superior.T);
end

if abs(F_tn) > abs(F_scomxlong + F_saxlong + F_spxlong)
    tau_s2 = (F_tn)/(Superior.B2*Superior.T);
    tau_s3 = (F_tn)/(Superior.B3*Superior.T);
else
    tau_s2 = (F_scomxlong + F_saxlong + F_spxlong)/(Superior.B2*Superior.T);
    tau_s3 = (F_scomxlong + F_saxlong + F_spxlong)/(Superior.B3*Superior.T);
end

% Safety Factors


%% Inferior Link

% Symbols
% longitudinal forces
syms F_ct F_cn F_icomxlong F_icomylong F_iaxlong F_iaylong
syms F_ipxlong F_ipylong F_spring2

% stresses and safety factors
syms sigma_ix sigma_i1y sigma_i2y sigma_i3y sigma_ibend1 sigma_ibend2
syms tau_i1 tau_i2 tau_i3 sigma_irupture moment_i1 moment_i2 
syms SF_ix SF_i1y SF_i2y SF_i3y SF_ibend1 SF_ibend2 SF_ishear1 SF_ishear2 SF_ishear3 SF_irupture

% longitudinal force calculations
F_ct = -Inferior.F_c(1)*sind(Inferior.theta) + Inferior.F_c(2)*cosd(Inferior.theta);
F_cn = Inferior.F_c(1)*cosd(Inferior.theta) + Inferior.F_c(2)*sind(Inferior.theta);
F_icomxlong = Inferior.m*Inferior.a(1)*cosd(Inferior.theta) + Inferior.m*Inferior.a(2)*sind(Inferior.theta) - Inferior.m*g*sind(Inferior.theta); 
F_icomylong = -Inferior.m*Inferior.a(1)*sind(Inferior.theta) + Inferior.m*Inferior.a(2)*cosd(Inferior.theta) - Inferior.m*g*cosd(Inferior.theta);
F_iaxlong = Inferior.F_ia(1)*cosd(Inferior.theta) + Inferior.F_ia(2)*sind(Inferior.theta);
F_iaylong = -Inferior.F_ia(1)*sind(Inferior.theta) + Inferior.F_ia(2)*cosd(Inferior.theta);
F_ipxlong = Inferior.F_ip(1)*cosd(Inferior.theta) + Inferior.F_ip(2)*sind(Inferior.theta);
F_ipylong = -Inferior.F_ip(1)*sind(Inferior.theta) + Inferior.F_isp(2)*cosd(Inferior.theta);
F_spring2 = -TorsionalSpring.Torque(3)*0.4*Inferior.L;

% stress calculations
% along x long
if abs(F_cn)>abs(F_icomxlong + F_iaxlong + F_ipxlong)
    sigma_ix = F_cn/((Inferior.H4-Inferior.H3)*Inferior.T);
else
    sigma_ix = (F_icomxlong + F_iaxlong + F_ipxlong)/((Inferior.H4-Inferior.H3)*Inferior.T);
end

% along y long
if abs(F_ct + F_icomylong)>abs(F_iaylong + F_ipylong + F_spring2)
    sigma_i1y = (F_ct + F_icomylong)/(Inferior.B1*Inferior.T);
    %add rupture sigma_irupture = 
else
    sigma_i1y = (F_iaylong + F_ipylong + F_spring2)/(Inferior.B1*Inferior.T);
    %add rupture sigma_irupture = 
end

if abs(F_ct)>abs(F_icomylong + F_iaylong + F_ipylong + F_spring2)
    sigma_i2y = F_ct / (Inferior.B2*Inferior.T);
    sigma_i3y = F_ct / (Inferior.B3*Inferior.T);
else
    sigma_i2y = (F_icomylong + F_iaylong + F_ipylong + F_spring2) / (Inferior.B2*Inferior.T);
    sigma_i3y = (F_icomylong + F_iaylong + F_ipylong + F_spring2) / (Inferior.B3*Inferior.T);
end

% bending
moment_i1 = Inferior.I*Inferior.alpha(3) + (Inferior.B3/2)*F_ct - (Inferior.B3/2 - Inferior.B2/2)*(F_icomylong + F_iaylong + F_ipylong + F_spring2);
moment_i2 = Inferior.I*Inferior.alpha(3) - (Inferior.L/2)*F_iaylong - (Inferior.H4 - Inferior.com(2) - Inferior.H1/2)*F_iaxlong + (Inferior.L/2)*F_ipylong - (Inferior.H4 - Inferior.com(2) - Inferior.H1/2)*F_ipxlong + ((Inferior.L/2)-0.4*Inferior.L)*F_spring2 + Inferior.com(2)*F_cn;

sigma_ibend1 = -moment_i1*((Inferior.H4-Inferior.H3)/2) / ((Inferior.B3*(Inferior.H4-Inferior.H3)^3)/12);
sigma_ibend2 = %idk what y and I is for this shape

% shear
if abs(F_cn + F_icomxlong) > abs(F_iaxlong + F_ipxlong)
    tau_i1 = (F_cn + F_icomxlong)/(Inferior.B1*Inferior.T);
else
    tau_i1 = (F_iaxlong + F_ipxlong)/(Inferior.B1*Inferior.T);
end

if abs(F_cn) > abs(F_scomxlong + F_saxlong + F_spxlong)
    tau_i2 = (F_tn)/(Superior.B2*Superior.T);
    tau_i3 = (F_tn)/(Superior.B3*Superior.T);
else
    tau_i2 = (F_scomxlong + F_saxlong + F_spxlong)/(Superior.B2*Superior.T);
    tau_i3 = (F_scomxlong + F_saxlong + F_spxlong)/(Superior.B3*Superior.T);
end

% Safety Factors
SF_ix = sigma_ix/E;
SF_i1y = sigma_i1y/E;
SF_i2y = sigma_i2y/E;
SF_i3y = sigma_i3y/E;
SF_ibend1 = sigma_ibend1/E;
SF_ibend2 = sigma_ibend2/E;
SF_ishear1 = tau_i1/E;
SF_ishear2 = tau_i2/E;
SF_ishear3 = tau_i3/E;
SF_irupture = sigma_irupture/E;


%% Anterior Link

% longitudinal forces
syms F_acomxlong F_acomylong F_asxlong F_asylong F_aixlong F_aiylong

% stresses
syms sigma_ax sigma_ay sigma_abend tau_a1 tau_a2 sigma_arupture

% longitudinal force calculations
% F_acomxlong = 
% F_acomylong = 
% F_asxlong = 
% F_axylong = 
% F_aixlong = 
% F_aiylong = 

% stress calculations
% along x long


% along y long and rupture


% bending


% shear


% Safety Factors



%% Posterior Link

% longitudinal forces
syms F_pcomxlong F_pcomylong F_psxlong F_psylong F_pixlong F_piylong

% stresses
syms sigma_px sigma_py sigma_pbend tau_p1 tau_p2 sigma_prupture

% longitudinal force calculations
% F_pcomxlong = 
% F_pcomylong = 
% F_psxlong = 
% F_pxylong = 
% F_pixlong = 
% F_piylong = 

% stress calculations
% along x long


% along y long and rupture


% bending


% shear


% Safety Factors




%% Velcro




%% Springs




%% Bolts




%% Bearings




%% return or modifying object values
% we will figure this out soon



%% Safety Factors Calculations




end

