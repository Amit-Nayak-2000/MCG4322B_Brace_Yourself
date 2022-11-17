%User provided parameters
mass = 56.7; %kilograms
height = 1.73; %metres
thighdiameter = 0.1; %metres
calfdiameter = 0.08; %metres

%Thigh/Calf Length from Winters Segment Model
thighlength = (0.530 - 0.285)*height;
calflength = (0.285 - 0.0039)*height;
%segment mass
Mcalf = 0.0465*mass;
%Radius of Gyration (Proximal)
Kcalf = 0.528*calflength;
%Moment of Inertia Calf
Icalf = Mcalf*Kcalf^2;
%distance to com of Calf from proximal joint
distcom = 0.433*calflength;

%Instantiate Objects
S = SuperiorLink;
A = AnteriorLink;
In = InferiorLink;
P = PosteriorLink;
T1 = TorsionalSpring;
T2 = TorsionalSpring;



%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2);

%Initialize Torsional Springs:
GetInitKinematics(S,In,A,P, T1, T2)
T1 = initSpring(T1, mass, S, A);
T2 = initSpring(T2, mass, In, P);


%Parse Winters Data
WinterData = Parse_Winter_Data("Winter_Appendix_data_fixed.xlsx");
kinematicsdata = WinterData{3};
rxnforcedata = WinterData{5};

startframe = 28; %HCR
endframe = 96; %Just Before HCR
TorqueOnCalf = zeros(1 ,endframe - startframe + 1);
totalPE = zeros(1 ,endframe - startframe + 1);
framess = zeros(1 ,endframe - startframe + 1);
%bio knee moment is col 15 in Winter's Data
biokneemoment = zeros(1, endframe - startframe + 1);
newkneemoment = zeros(1, endframe - startframe + 1);
percentage = zeros(1, endframe - startframe + 1);

g = [0; -9.81; 0];

for i=startframe:endframe
    
dataindex = i - startframe + 1;

%Obtain biological kinematics of calf and thigh.
kincalf = [kinematicsdata(i,16), kinematicsdata(i,17), kinematicsdata(i,18), 0, 0, 0; 
           kinematicsdata(i,19), kinematicsdata(i,20), kinematicsdata(i,21), 0, 0, 0;
           0, 0, 0, kinematicsdata(i,13), kinematicsdata(i,14), kinematicsdata(i,15);];
       
kinthigh = [kinematicsdata(i,26), kinematicsdata(i,27), kinematicsdata(i,28), 0, 0, 0; 
           kinematicsdata(i,29), kinematicsdata(i,30), kinematicsdata(i,31), 0, 0, 0;
           0, 0, 0, kinematicsdata(i,23), kinematicsdata(i,24), kinematicsdata(i,25);];
       
%calculate kinematics
Kinematic_Modelling(S,In,P,A,kinthigh,kincalf, thighlength, calflength, T1, T2);

%bio knee moment is col 15 in Winter's Data
biokneemoment(dataindex) = rxnforcedata(i, 15);

%calculate forces
Kinetic_Saggital(S,In,P,A,T1,T2);
BraceMass = 2*(S.m + A.m + In.m + P.m);
NonDimFactor = (56.7 + BraceMass) / 56.7;

%multiplied by 2 since both sides of the knee
TorqueOnCalf(dataindex) =  -2*(In.H4 + In.offset)*In.F_cn;
totalPE(dataindex) = 2*(T1.K*(T1.theta-T1.theta0)^2 + T2.K*(T2.theta-T2.theta0)^2);


%this is essentially bio torque - torque from calf.
% Tknee = Icalf*calfalpha - [0;0;TorqueOnCalf(dataindex)] - cross(rcom, Mcalf*calfacel) - cross(rcom, Mcalf*g) - cross(rankle, Fankle) - Tankle;
% newkneemoment(dataindex) = Tknee(3); %fix this

newkneemoment(dataindex) = NonDimFactor*biokneemoment(dataindex) - TorqueOnCalf(dataindex);

framess(dataindex) = kinematicsdata(i, 1);
percentage(dataindex) = ((i - startframe + 1)/(endframe - startframe + 1)) * 100;
disp(percentage(dataindex) + "% completed.");
    
end