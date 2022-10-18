function [] = Init_System(mass,height,S,In,P,A,T1,T2)
%INIT_SYSTEM 
%Initialize System Objects based on Mass and Height.

%Thigh/Calf Length from Winters Segment Model
%Need to find a better way for thigh and calf diameter, but currently its
%hard coded for the purpose of sample calculations. 
thighlength = (0.530 - 0.285)*height;
thighdiameter = 0.1;
calflength = (0.285 - 0.0039)*height;
calfdiameter = 0.08;


%Assign Dimensions to Objects
%Lengths are in m.

%Superior Link
S.H4 = 0.4*thighlength;
S.H3 = 0.87*S.H4;
S.H2 = 0.33*S.H4;
S.H1 = 0.2*S.H4;

S.B1 = 1.1*S.H1; 
S.B2 = S.B1 / 2; 
S.B3 = thighdiameter / 2;
S.L = 0.8*S.B1;

%Inferior Link
In.H4 = 0.3*calflength;
In.H3 = 0.87*In.H4;
In.H2 = 0.33*In.H4;
In.H1 = 0.2*In.H4;

In.B1 = 1.5*S.B1; 
In.B2 = In.B1 / 2; 
In.B3 = calfdiameter / 2;
In.L = 0.8*In.B1;

%Anterior Link
A.B = 0.35*S.B1;
A.H = 0.0565;
A.L = 0.8*A.H;

%Posterior Link
P.B = 0.35*S.B1;
P.H = 0.0565;
P.L = 0.8*P.H;

thickness = 0.5/100;

S.T = thickness;
A.T = thickness;
In.T = thickness;
P.T = thickness;


%Old Values
% S.B1 = 0.03; 
% S.B2 = 0.015; 
% S.B3 = 0.05;
% S.L = 0.8*S.B1;
% S.H4 = 0.15; 
% S.H3 = 0.13;
% S.H2 = 0.05;
% S.H1 = 0.03;

end

