%User provided parameters (WILL BE FROM GUI)
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

%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2);
%Initialize Torsional Springs:
GetInitKinematics(S, In, A, P, T1, T2);
T1 = initSpring(T1, mass, S, A);
T2 = initSpring(T2, mass, In, P);


%boolean to check if safety factors are satisfied
safetyfactorsatisfied = 0;

%Parametrization Loop
while (safetyfactorsatisfied == 0)
    %loop thru the gait cycle and obtain safety factors
%     GaitLoop(S,In,P,A,thighlength,calflength,T1,T2);
    
    %assume safety factors satisfied, if found not satisfied it is set back
    %to 0.
    disp("HERE");
    safetyfactorsatisfied = 1;
    
    %do this for links, springs, & bolts
    %if(SF < 2)
    %   obj.t = obj.t * 1.25;
    %safetyfactorsatisfied = 0;
    
    %if(SF > 3)
    %   obj.t = obj.t * 0.5
    %safetyfactorsatisfied = 0;
   
    
end

%Output final safety factors to log file here...


%Output solidworks dimensions here...


%Contribution Loop:


