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
%% stresses
syms sigma_ix sigma_i1y sigma_i2y sigma_i3y sigma_ibend1 sigma_ibend2
syms tau_i1 tau_i2 tau_i3 sigma_irupture

%% longitudinal force calculations
F_ct = -Inferior.F_c(1)*sind(Inferior.theta) + Inferior.F_c(2)*cosd(Inferior.theta);
F_cn = Inferior.F_c(1)*cosd(Inferior.theta) + Inferior.F_c(2)*sind(Inferior.theta);
F_icomxlong = Inferior.m*Inferior.a(1)*cosd(Inferior.theta) + Inferior.m*Inferior.a(2)*sind(Inferior.theta) - Inferior.m*g*sind(Inferior.theta); 
F_icomylong = -Inferior.m*Inferior.a(1)*sind(Inferior.theta) + Inferior.m*Inferior.a(2)*cosd(Inferior.theta) - Inferior.m*g*cosd(Inferior.theta);
F_iaxlong = Inferior.F_ia(1)*cosd(Inferior.theta) + Inferior.F_ia(2)*sind(Inferior.theta);
F_iaylong = -Inferior.F_ia(1)*sind(Inferior.theta) + Inferior.F_ia(2)*cosd(Inferior.theta);
F_ipxlong = Inferior.F_ip(1)*cosd(Inferior.theta) + Inferior.F_ip(2)*sind(Inferior.theta);
F_ipylong = -Inferior.F_ip(1)*sind(Inferior.theta) + Inferior.F_isp(2)*cosd(Inferior.theta);
F_spring2 = -TorsionalSpring.Torque(3)*0.4*Inferior.L; %i think its the 0.4 of the superior link right? check

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


