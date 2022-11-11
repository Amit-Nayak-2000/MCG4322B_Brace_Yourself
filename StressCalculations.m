function [] = SuperiorStress()
% calculates stresses related to superior link
% inputs: ()
% output: [ , , , , ]

% description

%% Symbolic Variables
% constants
g = 9.81;

% longitudinal forces
syms F_tt F_tn F_scomxlong F_scomylong F_saxlong F_saylong
syms F_spxlong F_spylong F_spring1

% stresses
syms sigma_sx sigma_s1y sigma_s2y sigma_s3y sigma_sbend1 sigma_sbend2
syms tau_s1 tau_s2 tau_s3 sigma_srupture

%% longitudinal force calculations
F_tt = -Superior.F_t(1)*sind(Superior.theta) + Superior.F_t(2)*cosd(Superior.theta);
F_tn = Superior.F_t(1)*cosd(Superior.theta) + Superior.F_t(2)*sind(Superior.theta);
F_scomxlong = Superior.m*Superior.a(1)*cosd(Superior.theta) + Superior.m*Superior.a(2)*sind(Superior.theta) - Superior.m*g*sind(Superior.theta); 
F_scomylong = -Superior.m*Superior.a(1)*sind(Superior.theta) + Superior.m*Superior.a(2)*cosd(Superior.theta) - Superior.m*g*cosd(Superior.theta);
F_saxlong = Superior.F_sa(1)*cosd(Superior.theta) + Superior.F_sa(2)*sind(Superior.theta);
F_saylong = -Superior.F_sa(1)*sind(Superior.theta) + Superior.F_sa(2)*cosd(Superior.theta);
F_spxlong = Superior.F_sp(1)*cosd(Superior.theta) + Superior.F_sp(2)*sind(Superior.theta);
F_spylong = -Superior.F_sp(1)*sind(Superior.theta) + Superior.F_sp(2)*cosd(Superior.theta);
F_spring1 = TorsionalSpring.Torque(3)*0.4*Superior.L;

%% stress calculations


%% return or modifying object values
% we will figure this out soon



end
function [] = InferiorStress()
% calculates stresses related to inferior link
% inputs: 
% output: 

% description

%% Symbolic Variables
% constants
g = 9.81;

% longitudinal forces
syms F_ct F_cn F_icomxlong F_icomylong F_iaxlong F_iaylong
syms F_ipxlong F_ipylong F_spring2

% stresses
syms sigma_ix sigma_i1y sigma_i2y sigma_i3y sigma_ibend1 sigma_ibend2
syms tau_i1 tau_i2 tau_i3 sigma_irupture

%% longitudinal force calculations
F_ct = -Inferior.F_c(1)*sind(Inferior.theta) + Inferior.F_c(2)*cosd(Inferior.theta);
F_cn = Inferior.F_c(1)*cosd(Inferior.theta) + Inferior.F_c(2)*sind(Inferior.theta);
F_icomxlong = Inferior.m*Inferior.a(1)*cosd(Inferior.theta) + Inferior.m*Inferior.a(2)*sind(Inferior.theta) - Inferior.m*g*sind(Inferior.theta); 
F_icomylong = -Inferior.m*Inferior.a(1)*sind(Inferior.theta) + Inferior.m*Inferior.a(2)*cosd(Inferior.theta) - Inferior.m*g*cosd(Inferior.theta);
F_iaxlong = Inferior.F_sa(1)*cosd(Inferior.theta) + Inferior.F_sa(2)*sind(Inferior.theta);
F_iaylong = -Inferior.F_sa(1)*sind(Inferior.theta) + Inferior.F_sa(2)*cosd(Inferior.theta);
F_ipxlong = Inferior.F_sp(1)*cosd(Inferior.theta) + Inferior.F_sp(2)*sind(Inferior.theta);
F_ipylong = -Inferior.F_sp(1)*sind(Inferior.theta) + Inferior.F_sp(2)*cosd(Inferior.theta);
F_spring2 = -TorsionalSpring.Torque(3)*0.4*Superior.L; %i think its the 0.4 of the superior link right? check

%% stress calculations


%% return or modifying object values
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


