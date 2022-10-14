function [] = Kinematic_Modelling(Superior,Inferior,Posterior,Anterior, KinThigh, KinCalf)
%KINEMATIC_MODELLING 
%
%Inverse kinematics will be used to get angular positions, velocities, and
%accelerations of the Anterior and Posterior links.
%
%Forward kinematics will be used to get the linear position, velocities and
%accelerations of the Anterior and Posterior links. 

%KinThigh and KinCalf are matrices of position, velocity and acceleration
%from Winter's Data.

%% Start of inverse kinematics
%1 is superior, 2 is anterior, 3 is inferior, 4 is posterior

%Position:
%r1 + r2 + r3 + r4 = 0
%theta_a is anterior theta
%theta_p is posterior theta
syms theta_a theta_p
r1 = [Superior.L*cosd(Superior.theta(3)); Superior.L*sind(Superior.theta(3))];
r2 = [Anterior.L*cosd(theta_a); Anterior.L*sind(theta_a)];
r3 = [Inferior.L*cosd(Inferior.theta(3)); Inferior.L*sind(Inferior.theta(3))];
r4 = [Posterior.L*cosd(theta_p); Posterior.L*sind(theta_p)];

positioneqn = r1 + r2 + r3 + r4 == 0;
solve(positioneqn, [theta_a theta_p]);
%assign theta_a to Anterior.theta and theta_p to Posterior.theta

%Velocity
%d/dt(r1 + r2 + r3 + r4) = 0
syms w_a w_p;
%w_a is omega anterior, w_p is omega posterior
v1 = [-Superior.L*Superior.omega(3)*sind(Superior.theta(3)); Superior.L*Superior.omega(3)*cosd(Superior.theta(3))];
v2 = [-Anterior.L*w_a*sind(Anterior.theta(3)); Anterior.L*w_a*cosd(Anterior.theta(3))];
v3 = [-Inferior.L*Inferior.omega(3)*sind(Inferior.theta(3)); Inferior.L*Inferior.omega(3)*cosd(Inferior.theta(3))];
v4 = [-Posterior.L*w_p*sind(Posterior.theta(3)); Posterior.L*w_p*cosd(Posterior.theta(3))];

velocityeqn = v1 + v2 + v3 + v4 == 0;
[omega_soln_1, omega_soln_2] = solve(velocityeqn, [w_a w_p]);

%assign w_a to Anterior.omega and w_p to Posterior.omega
Anterior.omega(3) = double(omega_soln_1);
Posterior.omega(3) = double(omega_soln_2);

%Acceleration
%d^2/dt^2(r1 + r2 + r3 + r4) = 0
syms a_a a_p;
%a_a is Anterior.alpha a_p is Posterior.alpha
a1 = [-Superior.L*Superior.alpha(3)*sind(Superior.theta(3)) - Superior.L*(Superior.omega(3)^2)*cosd(Superior.theta(3)); 
    Superior.L*Superior.alpha(3)*cosd(Superior.theta(3)) - Superior.L*(Superior.omega(3)^2)*sind(Superior.theta(3))];

a2 = [-Anterior.L*a_a*sind(Anterior.theta(3)) - Anterior.L*(Anterior.omega(3)^2)*cosd(Anterior.theta(3)); 
    Anterior.L*a_a*cosd(Anterior.theta(3)) - Anterior.L*(Anterior.omega(3)^2)*sind(Anterior.theta(3))];

a3 = [-Inferior.L*Inferior.alpha(3)*sind(Inferior.theta(3)) - Inferior.L*(Inferior.omega(3)^2)*cosd(Inferior.theta(3)); 
    Inferior.L*Inferior.alpha(3)*cosd(Inferior.theta(3)) - Inferior.L*(Inferior.omega(3)^2)*sind(Inferior.theta(3))];

a4 = [-Posterior.L*a_p*sind(Posterior.theta(3)) - Posterior.L*(Posterior.omega(3)^2)*cosd(Posterior.theta(3)); 
    Posterior.L*a_p*cosd(Posterior.theta(3)) - Posterior.L*(Posterior.omega(3)^2)*sind(Posterior.theta(3))];

acceleqn = a1 + a2 + a3 + a4 == 0;
[alpha_soln_1, alpha_soln_2] = solve(acceleqn, [a_a a_p]);

%assign a_a to Anterior.alpha and a_p to Posterior.alpha
Anterior.alpha(3) = double(alpha_soln_1);
Posterior.alpha(3) = double(alpha_soln_2);

%% End of inverse kinematics
%% Start of forward kinematics
%KinThigh and KinCalf are matrices.
%1st col is position, 2nd col is velocity, 3rd col is acceleration. 

%Superior Link:
%calculate aboslute position
Superior.com_abs = KinThigh(:, 1) + Superior.com;
%calculate linear velocity
Superior.v = KinThigh(:, 2) + cross(Superior.omega, Superior.com);
%calculate linear acceleration
Superior.a = KinThigh(:, 3); + cross(Superior.alpha, Superior.com) + cross(Superior.omega, cross(Superior.omega, Superior.com));

%Joint between Superior and Anterior Links:
SA = Superior.com_abs + Superior.rsa;
vSA = Superior.v + cross(Superior.omega, Superior.rsa);
aSA = Superior.a + cross(Superior.alpha, Superior.rsa) + cross(Superior.omega, cross(Superior.omega, Superior.rsa));

%Anterior Link:
Anterior.com_abs = SA + Anterior.rsa;
Anterior.v = vSA + cross(Anterior.omega, Anterior.rsa);
Anterior.a = aSA + cross(Anterior.alpha, Anterior.rsa) + cross(Anterior.omega, cross(Anterior.omega, Anterior.rsa));

%Joint between Superior and Posterior Links:
SP = Superior.com_abs + Superior.rsp;
vSP = Superior.v + cross(Superior.omega, Superior.rsp);
aSP = Superior.a + cross(Superior.alpha, Superior.rsp) + cross(Superior.omega, cross(Superior.omega, Superior.rsp));

%Posterior Link:
Posterior.com_abs = SP + Posterior.rsp;
Posterior.v = vSP + cross(Posterior.omega, Posterior.rsp);
Posterior.a = aSP + cross(Posterior.alpha, Posterior.rsp) + cross(Posterior.omega, cross(Posterior.omega, Posterior.rsp));

%Inferior Link:
%calculate aboslute position
Inferior.com_abs = KinCalf(:, 1) + Inferior.com;
%calculate linear velocity
Inferior.v = KinCalf(:, 2) + cross(Inferior.omega, Inferior.com);
%calculate linear acceleration
Inferior.a = KinCalf(:, 3); + cross(Inferior.alpha, Inferior.com) + cross(Inferior.omega, cross(Inferior.omega, Inferior.com));

%% End of forward kinematics
end
