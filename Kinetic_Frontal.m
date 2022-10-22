function [] = Kinetic_Frontal(Superior,Inferior,Posterior,Height,Weight)
%KINETIC MODELLING FRONTAL PLANE
%Inputs: Link objects
%Output: Updated force attributes within objects.

%This function uses newtonian mechanics to solve for forces on the links.

%Knowns: Masses, Moments of Inertia
%Unknowns: Forces between body and brace.

%Process: 
%Construct F = 0 for z axis and T = 3.3% body weight times height
%for x axis for each link. 

%Assume that the rotation about the y axis is negligible compared to the 
%rotation about the x and z axes. The program will be updated to calculate
%the y axis rotation if time allows.

%Combine all the equations of motion and solve for unknowns. 
%Symbolic variables will be assigned to unknowns initially. 
%% Symbolic Variables

syms F_tz F_cz F_kz OA_KAM Healthy_KAM


%% Kinetics Equations

%Sum forces in Z
Fz = -F_tz + -F_cz + F_kz ==0;

%Sum Moments
%To do add y forces x-prod
Mz = OA_KAM + F_tz*(Superior.H4*cosd(Superior.theta) +...
    0.5*Posterior.H*sind(Posterior.theta))+ F_cz*(Inferior.H4*cosd(Inferior.theta)...
    - 0.5*Posterior.H*sind(Posterior.theta)) == Healthy_KAM;

%% Solve system of equations
syseqns = [Fz, Mz];

end

