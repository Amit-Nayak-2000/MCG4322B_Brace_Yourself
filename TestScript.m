%Test Script

%Mass and Height parameters
mass = 56.7; %kilograms
height = 1.524; %metres

%Thigh/Calf Length from Winters Segment Model
%Need to find a better way for thigh and calf diameter, but currently its
%hard coded for the purpose of sample calculations. 
thighlength = (0.530 - 0.285)*height;
thighdiameter = 0.1;
calflength = (0.285 - 0.0039)*height;
calfdiameter = 0.08;

%Instantiate Objects
S = SuperiorLink;
A = AnteriorLink;
In = InferiorLink;
P = PosteriorLink;
T1 = TorsionalSpring;
T2 = TorsionalSpring;

disp("Link and Spring Object Instantiated.");

%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2);

disp("Link and Spring Objects Initialized.");

%Add subfolder to path in order to Parse.
addpath(genpath("Winter_Data"));
% %Parse Winter's Data
% SegmentKinematics = importdata("Winter_Data/Winter_Appendix_data_A.3.csv");
% disp("Winter's Data Parsed.");

%Obtain kinematic data of thigh and calf to compute kinematics of system.

%Column vectors of position, velocity, acceleration, angular position,
%angular velocity and angular acceleration. 
%Format in each column in terms of unit vectors is as follows [i; j; k].

S.theta = 0;
S = calculateCOM(S, thighlength);

In.theta = 10;
In = calculateCOM(In, calflength);




















