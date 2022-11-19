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
VT = Velcro;
VC = Velcro;
Blt = Bolt;
Brng = Bearing;
SF = SafetyFactor;

%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2,VT,VC,Blt,Brng);
%Initialize Torsional Springs:
GetInitKinematics(S, In, A, P, T1, T2);
T1 = initSpring(T1, mass, S, A);
T2 = initSpring(T2, mass, In, P);


%boolean to check if safety factors are satisfied
safetyfactorsatisfied = 0;

% disp("Initial VC W: ");
% disp(VC.W);
% 
% disp("Initial VC T: ");
% disp(VT.W);

%Parametrization Loop
while (safetyfactorsatisfied == 0)
    %loop thru the gait cycle and obtain safety factors
    [SupSFArr,AntSFArr,PosSFArr,InfSFArr,T1SFArr,T2SFArr,VtSFArr,VcSFArr] = GaitLoop(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass);
    
    %assume SF satisfied, then check. If SF not satsified, then toggle to 0
    safetyfactorsatisfied = 1;
    
    %Superior Link Parametrization
    %obtain minimum SF & index thru gait cycle.
    SuperiorSatisfied = 0;
    [MinSup, SupIndex] = min(SupSFArr);
    while(SuperiorSatisfied == 0)
        if(MinSup > 3)
            %make sure to recheck after everything has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            S.T = 0.8*S.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27);
            MinSup = SF.SF_sup;
        elseif(MinSup < 2)
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            S.T = 1.4*S.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27);
            MinSup = SF.SF_sup;
        else
            %Superior Min SF is satisfied.
            SuperiorSatisfied = 1;
        end
            
    end
    
    
%     %Calf Velcro Parametrization
%     if(SF.SF_VC > 3)
%         VC.W = 0.5*VC.W;
%         safetyfactorsatisfied = 0;
%     elseif(SF.SF_VC < 2)
%         VC.W = 1.5*VC.W;
%         safetyfactorsatisfied = 0;
%     end
%     
%     %Thigh Velcro Parametrization
%     if(SF.SF_VT > 3)
%         VT.W = 0.5*VT.W;
%         safetyfactorsatisfied = 0;
%     elseif(SF.SF_VT < 2)
%         VT.W = 1.5*VT.W;
%         safetyfactorsatisfied = 0;
%     end
    
    
        
    
%     %assume safety factors satisfied, if found not satisfied it is set back
%     %to 0.
%     disp("HERE");
    
    
    %do this for links, springs, & bolts
    %if(SF < 2)
    %   obj.t = obj.t * 1.25;
    %safetyfactorsatisfied = 0;
    
    %if(SF > 3)
    %   obj.t = obj.t * 0.5
    %safetyfactorsatisfied = 0;
   
    
end

% disp("Final VC W: ");
% disp(VC.W);
% 
% disp("Final VC T: ");
% disp(VT.W);




%Output final safety factors to log file here...


%Output solidworks dimensions here...


%Contribution Loop:


