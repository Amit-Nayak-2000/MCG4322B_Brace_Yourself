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

%Parametrization Loop
while (safetyfactorsatisfied == 0)
    %loop thru the gait cycle and obtain safety factors
    disp("Computing Initial Calculations.");
    [SupSFArr,AntSFArr,PosSFArr,InfSFArr,T1SFArr,T2SFArr,VtSFArr,VcSFArr] = GaitLoop(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass);
    
    %assume SF satisfied, then check. If SF not satsified, then toggle to 0
    safetyfactorsatisfied = 1;
    
    %% Superior Link Parametrization
    disp("Optimizing Superior Link.");
    %Flag if superior link is satisfied WRT Safety Factor Range.
    SuperiorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinSup, SupIndex] = min(SupSFArr);
    while(SuperiorSatisfied == 0)
        if(MinSup > 3)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            S.T = 0.75*S.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27);
            MinSup = SF.SF_sup;
        elseif(MinSup < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            S.T = 1.5*S.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27);
            MinSup = SF.SF_sup;
        else
            %Superior Min SF is satisfied.
            SuperiorSatisfied = 1;
        end
    end
    
    
    %% Inferior Link Parametrization
    disp("Optimizing Inferior Link.");
    %Flag if inferior link is satisfied WRT Safety Factor Range.
    InferiorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinInf, InfIndex] = min(InfSFArr);
    while(InferiorSatisfied == 0)
        if(MinInf > 3)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            In.T = 0.75*In.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, InfIndex+27);
            MinInf = SF.SF_inf;
        elseif(MinInf < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            In.T = 1.5*In.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, InfIndex+27);
            MinInf = SF.SF_inf;
        else
            %Inferior Min SF is satisfied.
            InferiorSatisfied = 1;
        end
    end
    
    %% Anterior Link Parametrization
    disp("Optimizing Anterior Link.");
    %Flag if anterior link is satisfied WRT Safety Factor Range.
    AnteriorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinAnt, AntIndex] = min(AntSFArr);
    while(AnteriorSatisfied == 0)
        if(MinAnt > 3)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            A.T = 0.75*A.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, AntIndex+27);
            MinAnt = SF.SF_ant;
        elseif(MinAnt < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            A.T = 1.5*A.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, AntIndex+27);
            MinAnt = SF.SF_ant;
        else
            %Inferior Min SF is satisfied.
            AnteriorSatisfied = 1;
        end
    end
    
    %% Posterior Link Parametrization
    disp("Optimizing Posterior Link.");
    %Flag if posterior link is satisfied WRT Safety Factor Range.
    PosteriorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinPos, PosIndex] = min(PosSFArr);
    while(PosteriorSatisfied == 0)
        if(MinPos > 3)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            P.T = 0.75*P.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, PosIndex+27);
            MinPos = SF.SF_pos;
        elseif(MinPos < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            P.T = 1.5*P.T;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, PosIndex+27);
            MinPos = SF.SF_pos;
        else
            %Inferior Min SF is satisfied.
            PosteriorSatisfied = 1;
        end
    end
    
    %% Thigh Velcro Parametrization
    disp("Optimizing Thigh Velcro.");
    %Flag if thigh velcro is satisfied WRT Safety Factor Range.
    VTsatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinVT, VTIndex] = min(VtSFArr);
    while(VTsatisfied == 0)
        if(MinVT > 3)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            VT.W = 0.75*VT.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VTIndex+27);
            MinVT = SF.SF_VT;
        elseif(MinVT < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            VT.W = 1.25*VT.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VTIndex+27);
            MinVT = SF.SF_VT;
        else
            %Inferior Min SF is satisfied.
            VTsatisfied = 1;
        end
    end
    
    %% Calf Velcro Parametrization
    disp("Optimizing Calf Velcro.");
    %Flag if calf velcro is satisfied WRT Safety Factor Range.
    VCsatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinVC, VCIndex] = min(VcSFArr);
    while(VCsatisfied == 0)
        if(MinVC > 3)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            VC.W = 0.75*VC.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VCIndex+27);
            MinVC = SF.SF_VC;
        elseif(MinVC < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            VC.W = 1.25*VC.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VCIndex+27);
            MinVC = SF.SF_VC;
        else
            %Inferior Min SF is satisfied.
            VCsatisfied = 1;
        end
    end
      
end

%Output final safety factors to log file here...
%Output solidworks dimensions here...
