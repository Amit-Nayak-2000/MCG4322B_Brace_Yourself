function [Theta1,Theta2] = GetSpringAngles(Superior, Anterior, Inferior, Posterior)
%Inputs: Link Objects
%Outputs: Spring Angles

%this vector is negative so both vectors have the same tail.
vector1 = [-Superior.L*cosd(Superior.theta); -Superior.L*sind(Superior.theta); 0];
vector2 = [Anterior.L*cosd(Anterior.theta); Anterior.L*sind(Anterior.theta); 0];

Theta1 = atan2d(norm(cross(vector1,vector2)), dot(vector1,vector2));


%this vector is negative so both vectors have the same tail.
vector3 = [-Inferior.L*cosd(Inferior.theta); -Inferior.L*sind(Inferior.theta); 0];
vector4 = [Posterior.L*cosd(Posterior.theta); Posterior.L*sind(Posterior.theta); 0];

Theta2 = atan2d(norm(cross(vector3,vector4)), dot(vector3,vector4));





end

