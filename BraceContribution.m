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


%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2);

%Initialize Torsional Springs:
T1 = initSpring(T1, mass, S, A);
T2 = initSpring(T2, mass, In, P);


%Parse Winters Data
WinterData = Parse_Winter_Data("Winter_Appendix_data_fixed.xlsx");
kinematicsdata = WinterData{3};
rxnforcedata = WinterData{5};

startframe = 28; %HCR
endframe = 96; %Just Before HCR

superiordata = zeros(endframe - startframe + 1, 9);
anteriordata = zeros(endframe - startframe + 1, 9);
inferiordata = zeros(endframe - startframe + 1, 9);
posteriordata = zeros(endframe - startframe + 1, 9);
spring1data = zeros(1 ,endframe - startframe + 1);
spring2data = zeros(1 ,endframe - startframe + 1);
totalextensivetorque = zeros(1 ,endframe - startframe + 1);
totalextensivetorque2 = zeros(1 ,endframe - startframe + 1);
totalPE = zeros(1 ,endframe - startframe + 1);
framess = zeros(1 ,endframe - startframe + 1);
NA1 = zeros(1 ,endframe - startframe + 1);
NA2 = zeros(1 ,endframe - startframe + 1);

%bio knee moment is 15

for i=startframe:endframe
    %Obtain biological kinematics of calf and thigh.
kincalf = [kinematicsdata(i,16), kinematicsdata(i,17), kinematicsdata(i,18), 0, 0, 0; 
           kinematicsdata(i,19), kinematicsdata(i,20), kinematicsdata(i,21), 0, 0, 0;
           0, 0, 0, kinematicsdata(i,13), kinematicsdata(i,14), kinematicsdata(i,15);];
       
kinthigh = [kinematicsdata(i,26), kinematicsdata(i,27), kinematicsdata(i,28), 0, 0, 0; 
           kinematicsdata(i,29), kinematicsdata(i,30), kinematicsdata(i,31), 0, 0, 0;
           0, 0, 0, kinematicsdata(i,23), kinematicsdata(i,24), kinematicsdata(i,25);];
       
%calculate kinematics
Kinematic_Modelling(S,In,P,A,kinthigh,kincalf, thighlength, calflength, T1, T2);


dataindex = i - startframe + 1;
superiordata(dataindex, 1) = S.com_abs(1);
superiordata(dataindex, 2) = S.com_abs(2);
superiordata(dataindex, 3) = S.v(1);
superiordata(dataindex, 4) = S.v(2);
superiordata(dataindex, 5) = S.a(1);
superiordata(dataindex, 6) = S.a(2);
superiordata(dataindex, 7) = S.theta;
superiordata(dataindex, 8) = S.omega(3);
superiordata(dataindex, 9) = S.alpha(3);

anteriordata(dataindex, 1) = A.com_abs(1);
anteriordata(dataindex, 2) = A.com_abs(2);
anteriordata(dataindex, 3) = A.v(1);
anteriordata(dataindex, 4) = A.v(2);
anteriordata(dataindex, 5) = A.a(1);
anteriordata(dataindex, 6) = A.a(2);
anteriordata(dataindex, 7) = A.theta;
anteriordata(dataindex, 8) = A.omega(3);
anteriordata(dataindex, 9) = A.alpha(3);

inferiordata(dataindex, 1) = In.com_abs(1);
inferiordata(dataindex, 2) = In.com_abs(2);
inferiordata(dataindex, 3) = In.v(1);
inferiordata(dataindex, 4) = In.v(2);
inferiordata(dataindex, 5) = In.a(1);
inferiordata(dataindex, 6) = In.a(2);
inferiordata(dataindex, 7) = In.theta;
inferiordata(dataindex, 8) = In.omega(3);
inferiordata(dataindex, 9) = In.alpha(3);

posteriordata(dataindex, 1) = P.com_abs(1);
posteriordata(dataindex, 2) = P.com_abs(2);
posteriordata(dataindex, 3) = P.v(1);
posteriordata(dataindex, 4) = P.v(2);
posteriordata(dataindex, 5) = P.a(1);
posteriordata(dataindex, 6) = P.a(2);
posteriordata(dataindex, 7) = P.theta;
posteriordata(dataindex, 8) = P.omega(3);
posteriordata(dataindex, 9) = P.alpha(3);

%calculate forces
Kinetic_Saggital(S,In,P,A,T1,T2);

[NA1(dataindex), NA2(dataindex)] = GetSpringAngles(S, A, In, P);

spring1data(dataindex) = T1.theta;
spring2data(dataindex) = T2.theta;
 
%-S.H4*
totalextensivetorque(dataindex) =  S.F_tn;
%-(In.H4 + In.offset)*
totalextensivetorque2(dataindex) =   In.F_cn;
totalPE(dataindex) = T1.K*(T1.theta-T1.theta0)^2 + T2.K*(T2.theta-T2.theta0)^2;

framess(dataindex) = kinematicsdata(i, 1);


percentage = ((i - startframe + 1)/(endframe - startframe + 1)) * 100;
disp(percentage + "% completed.");
    
end