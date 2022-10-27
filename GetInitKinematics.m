function [offset] = GetInitKinematics(Superior,Inferior,Anterior,Posterior, T1, T2)
%GETFEMORALOFFSET 
%Getting vertical distance between Superior and Inferior Links at 0 deg
%flexion.
%Same code as first part of Kinematic_Modelling
%Setting Superior and Posterior angles to 0 (standing straight)
syms theta_a theta_p
r1 = [Superior.L*cosd(0); Superior.L*sind(0)];
r2 = [Anterior.L*cosd(theta_a); Anterior.L*sind(theta_a)];
r3 = [Inferior.L*cosd(0); Inferior.L*sind(0)];
r4 = [Posterior.L*cosd(theta_p); Posterior.L*sind(theta_p)];

positioneqn = r1 + r2 + r3 + r4 == 0;
thetas = solve(positioneqn, [theta_a theta_p]);

pt1 = double(thetas.theta_a(1,1));
pt2 = double(thetas.theta_a(2,1));
pt3 = double(thetas.theta_p(1,1));
pt4 = double(thetas.theta_p(2,1));

T1.beta = 180 - pt1 ; %assign betas to spring
T2.beta = 180 - pt1;

offsettheta = pt4;

offset = abs(Posterior.L*sind(offsettheta));
end

