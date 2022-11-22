function [omega_soln_1, omega_soln_2, alpha_soln_1, alpha_soln_2] = SetupEqns()
%Velocity
%d/dt(r1 + r2 + r3 + r4) = 0
syms w_a w_p theta_a theta_p;
%w_a is omega anterior, w_p is omega posterior
syms SpL SW ST SA AL AT IL IW IT IA PL PT  

syms theta_a theta_p
r1 = [SpL*cosd(ST); SpL*sind(ST)];
r2 = [AL*cosd(theta_a); AL*sind(theta_a)];
r3 = [IL*cosd(IT); IL*sind(IT)];
r4 = [PL*cosd(theta_p); PL*sind(theta_p)];

positioneqn = r1 + r2 + r3 + r4 == 0;
thetas = solve(positioneqn, [theta_a theta_p]);
%assign theta_a to Anterior.theta and theta_p to Posterior.theta
pt1 = thetas.theta_a(1,1);
pt2 = thetas.theta_a(2,1);
pt3 = thetas.theta_p(1,1);
pt4 = thetas.theta_p(2,1);










v1 = [-SpL*SW*sind(ST); SpL*SW*cosd(ST)];
v2 = [-AL*w_a*sind(AT); AL*w_a*cosd(AT)];
v3 = [-IL*IW*sind(IT); IL*IW*cosd(IT)];
v4 = [-PL*w_p*sind(PT); PL*w_p*cosd(PT)];

velocityeqn = v1 + v2 + v3 + v4 == 0;
[omega_soln_1, omega_soln_2] = solve(velocityeqn, [w_a w_p]);

%Acceleration
%d^2/dt^2(r1 + r2 + r3 + r4) = 0
syms a_a a_p;
%a_a is Anterior.alpha a_p is Posterior.alpha
a1 = [-SpL*SA*sind(ST) - SpL*(SW^2)*cosd(ST); 
    SpL*SA*cosd(ST) - SpL*(SW^2)*sind(ST)];

a2 = [-AL*a_a*sind(AT) - AL*(w_a^2)*cosd(AT); 
    AL*a_a*cosd(AT) - AL*(w_a^2)*sind(AT)];

a3 = [-IL*IA*sind(IT) - IL*(IW^2)*cosd(IT); 
    IL*IA*cosd(IT) - IL*(IW^2)*sind(IT)];

a4 = [-PL*a_p*sind(PT) - PL*(w_p^2)*cosd(PT); 
    PL*a_p*cosd(PT) - PL*(w_p^2)*sind(PT)];

acceleqn = a1 + a2 + a3 + a4 == 0;
[alpha_soln_1, alpha_soln_2] = solve(acceleqn, [a_a a_p]);


end

