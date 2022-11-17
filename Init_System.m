function [] = Init_System(mass,height,S,In,P,A,T1,T2,VT,VC,Bolt,Bearing)
%INIT_SYSTEM 
%Initialize System Objects based on User Params.

%Mass, height, thigh diameter and calf diameter are user inputs to the GUI.
%Thigh/Calf Length from Winters Segment Model
thighlength = (0.530 - 0.285)*height;
thighdiameter = 0.1;
calflength = (0.285 - 0.0039)*height;
calfdiameter = 0.08;
bolt_hole_size = 0.0034;

%Assign Dimensions to Objects
%Lengths are in m.

%Superior Link
S.H4 = 0.4*thighlength;
S.H3 = 0.87*S.H4;
S.H2 = 0.33*S.H4;
S.H1 = 0.2*S.H4;

S.B1 = 0.83*S.H1; 
S.B2 = S.B1 / 2; 
S.B3 = thighdiameter / 2;
S.L = 0.8*S.B1;

%Inferior Link
In.H4 = 0.3*calflength;
In.H3 = 0.87*In.H4;
In.H2 = 0.33*In.H4;
In.H1 = 0.2*In.H4;

In.B1 = 1.34133*S.B1; 
In.B2 = In.B1 / 2; 
In.B3 = calfdiameter / 2;
In.L = 0.8*In.B1;

%Posterior Link
P.B = 0.35*S.B1;
P.H = 2.1319*S.B1;
P.L = 0.8*P.H;

%Anterior Link
A.B = 0.35*S.B1;
A.H = 2.69155*S.B1;
A.L = 0.8*A.H;

thickness = 0.5/100; 

S.T = thickness;
A.T = thickness;
In.T = thickness;
P.T = thickness;

%Assign bolt hole diameters CHANGE THIS

S.bolt_hole_diam=bolt_hole_size;
In.bolt_hole_diam=bolt_hole_size;
A.bolt_hole_diam=bolt_hole_size;
P.bolt_hole_diam=bolt_hole_size;


%call the inertial property methods for each link.
S = calculate_inertial_props(S);
A = calculate_inertial_props(A);
In = calculate_inertial_props(In);
P = calculate_inertial_props(P);

%Velcro
LVT=pi*thighdiameter;
WVT=0.2*LVT;

LVC=pi*calfdiameter;
WVC=0.2*LVC;

VT = initVelcro(VT,LVT,WVT);
VC = initVelcro(VC,LVC,WVC);

%Bolt
Bolt_diam=0.003; %[m]

Bolt = initBolt(Bolt,Bolt_diam);

%Bearing
Bearing_ID = 0.003; %[m]
Bearing_OD = 0.008; %[m]
Bearing.C_10=560; %[N]

Bearing=initBearing(Bearing,Bearing_ID,Bearing_OD);
end

