function [] = Kinematic_Modelling(Superior,Inferior,Posterior,Anterior)
%KINEMATIC_MODELLING 
%
%Inverse kinematics will be used to get angular positions, velocities, and
%accelerations of the Anterior and Posterior links.
%
%Forward kinematics will be used to get the linear position, velocities and
%accelerations of the Anterior and Posterior links. 

%Start of inverse kinematics
%1 is superior, 2 is anterior, 3 is inferior, 4 is posterior

%Position:
%r1 + r2 + r3 + r4 = 0
%theta_a is anterior theta
%theta_p is posterior theta
syms theta_a theta_p
r1 = [Superior.L*cosd(Superior.theta); Superior.L*sind(Superior.theta)];
r2 = [Anterior.L*cosd(theta_a); Anterior.L*sind(theta_a)];
r3 = [Inferior.L*cosd(Inferior.theta); Inferior.L*sind(Inferior.theta)];
r4 = [Posterior.L*cosd(theta_p); Posterior.L*sind(theta_p)];

positioneqn = r1 + r2 + r3 + r4 == 0;
solve(positioneqn, [theta_a theta_p]);
%assign theta_a to Anterior.theta and theta_p to Posterior.theta

%Velocity
%d/dt(r1 + r2 + r3 + r4) = 0
syms w_a w_p;
%w_a is omega anterior, w_p is omega posterior
v1 = [-Superior.L*Superior.omega*sind(Superior.theta); Superior.L*Superior.omega*cosd(Superior.theta)];
v2 = [-Anterior.L*w_a*sind(Anterior.theta); Anterior.L*w_a*cosd(Anterior.theta)];
v3 = [-Inferior.L*Inferior.omega*sind(Inferior.theta); Inferior.L*Inferior.omega*cosd(Inferior.theta)];
v4 = [-Posterior.L*w_p*sind(Posterior.theta); Posterior.L*w_p*cosd(Posterior.theta)];

velocityeqn = v1 + v2 + v3 + v4 == 0;
[omega_soln_1, omega_soln_2] = solve(velocityeqn, [w_a w_p]);

%assign w_a to Anterior.omega and w_p to Posterior.omega
Anterior.omega = double(omega_soln_1);
Posterior.omega = double(omega_soln_2);

%Acceleration
%d^2/dt^2(r1 + r2 + r3 + r4) = 0
syms a_a a_p;
%a_a is Anterior.alpha a_p is Posterior.alpha
a1 = [-Superior.L*Superior.alpha*sind(Superior.theta) - Superior.L*(Superior.omega^2)*cosd(Superior.theta); 
    Superior.L*Superior.alpha*cosd(Superior.theta) - Superior.L*(Superior.omega^2)*sind(Superior.theta)];

a2 = [-Anterior.L*a_a*sind(Anterior.theta) - Anterior.L*(Anterior.omega^2)*cosd(Anterior.theta); 
    Anterior.L*a_a*cosd(Anterior.theta) - Anterior.L*(Anterior.omega^2)*sind(Anterior.theta)];

a3 = [-Inferior.L*Inferior.alpha*sind(Inferior.theta) - Inferior.L*(Inferior.omega^2)*cosd(Inferior.theta); 
    Inferior.L*Inferior.alpha*cosd(Inferior.theta) - Inferior.L*(Inferior.omega^2)*sind(Inferior.theta)];

a4 = [-Posterior.L*a_p*sind(Posterior.theta) - Posterior.L*(Posterior.omega^2)*cosd(Posterior.theta); 
    Posterior.L*a_p*cosd(Posterior.theta) - Posterior.L*(Posterior.omega^2)*sind(Posterior.theta)];

acceleqn = a1 + a2 + a3 + a4 == 0;
[alpha_soln_1, alpha_soln_2] = solve(acceleqn, [a_a a_p]);

%assign a_a to Anterior.alpha and a_p to Posterior.alpha
Anterior.alpha = double(alpha_soln_1);
Posterior.alpha = double(alpha_soln_2);

%end of inverse kinematics

%start of forward kinematics

end
