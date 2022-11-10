function [] = SuperiorStress()
% calculates stresses related to superior link
% inputs: ()
% output: [ , , , , ]

% description

%% Symbolic Variables
% longitudinal forces
syms F_tt F_tn F_scomxlong F_scomylong F_saxlong F_saylong
syms F_spxlong F_spylong F_spring1

% stresses
syms sigma_sx sigma_s1y sigma_s2y sigma_s3y sigma_sbend1 sigma_sbend2
syms tau_s1 tau_s2 tau_s3 sigma_srupture

%% longitudinal force calculations
F_tt = -Superior.F_t(1)*sind(Superior.theta) + Superior.F_t(2)*cosd(Superior.theta);


%% stress calculations


%% return or modifying object values
% we will figure this out soon



end
function [] = InferiorStress()
% calculates stresses related to inferior link
% inputs: 
% output: 

% description

%% symbolic variables
% constants
g = 9.81;

% longitudinal forces
syms F_ct F_cn F_icomxlong F_icomylong F_iaxlong F_iaylong
syms F_ipxlong F_ipylong F_spring2

% stresses
syms sigma_ix sigma_i1y sigma_i2y sigma_i3y sigma_ibend1 sigma_ibend2
syms tau_i1 tau_i2 tau_i3 sigma_irupture
syms moment_i1 moment_i2

%% longitudinal force calculations
F_ct = -Inferior.F_c(1)*sind(Inferior.theta) + Inferior.F_c(2)*cosd(Inferior.theta);
F_cn = Inferior.F_c(1)*cosd(Inferior.theta) + Inferior.F_c(2)*sind(Inferior.theta);
F_icomxlong = Inferior.m*Inferior.a(1)*cosd(Inferior.theta) + Inferior.m*Inferior.a(2)*sind(Inferior.theta) - Inferior.m*g*sind(Inferior.theta); 
F_icomylong = -Inferior.m*Inferior.a(1)*sind(Inferior.theta) + Inferior.m*Inferior.a(2)*cosd(Inferior.theta) - Inferior.m*g*cosd(Inferior.theta);
F_iaxlong = Inferior.F_ia(1)*cosd(Inferior.theta) + Inferior.F_ia(2)*sind(Inferior.theta);
F_iaylong = -Inferior.F_ia(1)*sind(Inferior.theta) + Inferior.F_ia(2)*cosd(Inferior.theta);
F_ipxlong = Inferior.F_ip(1)*cosd(Inferior.theta) + Inferior.F_ip(2)*sind(Inferior.theta);
F_ipylong = -Inferior.F_ip(1)*sind(Inferior.theta) + Inferior.F_isp(2)*cosd(Inferior.theta);
F_spring2 = -TorsionalSpring.Torque(3)*0.4*Inferior.L; %CHECK

%% stress calculations
%along x long
if abs(F_cn)>abs(F_icomxlong + F_iaxlong + F_ipxlong)
    sigma_ix = F_cn/((Inferior.H4-Inferior.H3)*Inferior.T);
else
    sigma_ix = (F_icomxlong + F_iaxlong + F_ipxlong)/((Inferior.H4-Inferior.H3)*Inferior.T);
end

%along y long
if abs(F_ct + F_icomylong)>abs(F_iaxlong + F_ipxlong + F_sping2)
    sigma_i1y = (F_ct + F_icomylong)/(Inferior.B1*Inferior.T);
else
    sigma_i1y = (F_iaxlong + F_ipxlong + F_sping2)/(Inferior.B1*Inferior.T);
end

if abs(F_ct)>abs(F_icomylong + F_iaxlong + F_ipxlong + F_sping2)
    sigma_i2y = F_ct / (Inferior.B2*Inferior.T);
    sigma_i3y = F_ct / (Inferior.B3*Inferior.T);
else
    sigma_i2y = (F_icomylong + F_iaxlong + F_ipxlong + F_sping2) / (Inferior.B2*Inferior.T);
    sigma_i3y = (F_icomylong + F_iaxlong + F_ipxlong + F_sping2) / (Inferior.B3*Inferior.T);
end

%bending
moment_i1 = F_ct*Inferior.B3;
moment_i2 = Inferior.I*Inferior.alpha - (Inferior.L/2)*F_iaylong - (Inferior.H4 - Inferior.com(2) - J)*F_iaxlong + (Inferior.L/2)*F_ipylong - (Inferior.H4 - Inferior.com(2) - J)*F_ipxlong + ((Inferior.L/2)-0.4*Inferior.L)*F_spring2;
%^ i need to define J, also I*alpha... which index for alpha

sigma_ibend1 = -moment_i1*((Inferior.H4-Inferior.H3)/2) / ((Inferior.B3*(Inferior.H4-Inferior.H3)^3)/12)
%sigma_ibend2 = idk what y and I is for this shape

end
function [] = AnteriorStress()

end
function [] = PosteriorStress()

end
function [] = VelcroStress()

end
function [] = SpringStress()

end
function [] = BoltStress()

end
function [] = BearingStress()

end


