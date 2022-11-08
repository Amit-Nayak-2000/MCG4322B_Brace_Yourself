%Test Script

%User provided parameters
mass = 56.7; %kilograms
height = 1.73; %metres
thighdiameter = 0.1; %metres
calfdiameter = 0.08; %metres

%Thigh/Calf Length from Winters Segment Model
thighlength = (0.530 - 0.285)*height;
calflength = (0.285 - 0.0039)*height;


%Instantiate Objects
S = SuperiorLink;
A = AnteriorLink;
In = InferiorLink;
P = PosteriorLink;
T1 = TorsionalSpring;
T2 = TorsionalSpring;
ZF = Z_forces;

disp("Link and Spring Object Instantiated.");

%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2);

disp("Link and Spring Objects Initialized.");

%Parse Winters Data
WinterData = Parse_Winter_Data("Winter_Appendix_data_fixed.xlsx");
kinematicsdata = WinterData{3};
frame = 37; 

%Obtain biological kinematics of calf and thigh.
kincalf = [kinematicsdata(frame,16), kinematicsdata(frame,17), kinematicsdata(frame,18), 0, 0, 0; 
           kinematicsdata(frame,19), kinematicsdata(frame,20), kinematicsdata(frame,21), 0, 0, 0;
           0, 0, 0, kinematicsdata(frame,13), kinematicsdata(frame,14), kinematicsdata(frame,15);];
       
kinthigh = [kinematicsdata(frame,26), kinematicsdata(frame,27), kinematicsdata(frame,28), 0, 0, 0; 
           kinematicsdata(frame,29), kinematicsdata(frame,30), kinematicsdata(frame,31), 0, 0, 0;
           0, 0, 0, kinematicsdata(frame,23), kinematicsdata(frame,24), kinematicsdata(frame,25);];
 
disp("Biological Kinematic Data Obtained.");

Kinematic_Modelling(S,In,P,A,kinthigh,kincalf, thighlength, calflength, T1, T2);
disp("Kinematics Calculated.");

%Initialize Torsional Springs:
T1 = initSpring(T1, mass, S, A);
T2 = initSpring(T2, mass, In, P);
disp("Torsional Springs Initialized.");

%calculate forces
Kinetic_Saggital(S,In,P,A, T1, T2);
Kinetic_Frontal(S,In,P,ZF,frame,mass);
disp("Kinetics Calculated.");

disp("Frame: " + frame);

S.outputDimensions();
In.outputDimensions();
A.outputDimensions();
P.outputDimensions();












%notes
%Superior.theta = theta_thigh - 90 deg.
%Inferior.theta = theta_calf - 90 deg.

%leg indexes from winters (col, value):
%13, theta
%14, omega
%15, alpha
%16, comx
%17, velx
%18, accelx
%19, comy
%20, vely
%21, accely

%Thigh (col, value):
%23, theta
%24, omega
%25, alpha
%26, comx
%27, velx
%28, accelx
%29, comy
%30, vely
%31, accely 
