function [] = Kinetic_Frontal(Superior,Inferior,Posterior,Z_forces,frame,mass)
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

syms F_tz F_cz F_kz R_kz
    
%% Parse KAM Data

KAM_Data = Parse_Winter_Data("KAM_data.xlsx");

OA_KAM_Data = KAM_Data{1};
Healthy_KAM_Data = KAM_Data{2};

[tf,row_OA] = ismember(frame,OA_KAM_Data(:,3));
[tf,row_healthy] = ismember(frame,Healthy_KAM_Data(:,3));

OA_KAM=mass*OA_KAM_Data(row_OA,2);
M_k=mass*Healthy_KAM_Data(row_healthy,2);

%% Kinetics Equations

%Knee Brace Equations

%Sum forces in Z on the brace
Fz_br = F_tz + F_cz - F_kz == 0;

%Moment on lower brace
Mz_in=OA_KAM-M_k==F_cz*(Inferior.H4*cosd(Inferior.theta)...
    + 0.5*Posterior.H*sind(Posterior.theta));

%Moment on upper brace
Mz_s=OA_KAM-M_k==F_tz*(Superior.H4*cosd(Superior.theta)...
    +0.5*Posterior.H*sind(Posterior.theta));

%Sum of frontal moments on the brace
%Mz_br = -F_tz*(Superior.H4*cosd(Superior.theta)...
%    +0.5*Posterior.H*sind(Posterior.theta))...
%    +F_cz*(Inferior.H4*cosd(Inferior.theta)...
%    + 0.5*Posterior.H*sind(Posterior.theta)) == 0;

%Leg equations

%Sum of forces in Z on the lower leg
%Fz_leg = F_kz + R_kz - F_cz == 0;

%Sum of frontal moments on the lower leg
%Mz_leg = OA_KAM...
%    -F_cz*(Inferior.H4*cosd(Inferior.theta)...
%    + 0.5*Posterior.H*sind(Posterior.theta))-M_k == 0;

%% Solve system of equations
syseqns = [Fz_br, Mz_s, Mz_in];
sol = solve(syseqns,[F_tz, F_cz, F_kz]);

%Brace force on thigh
Z_forces.F_tz=double(sol.F_tz);

%Brace force on calf
Z_forces.F_cz=double(sol.F_cz);

%Brace force on knee
Z_forces.F_kz=double(sol.F_kz);

%Knee reaction force
%Z_forces.R_kz=double(sol.R_kz);

end

