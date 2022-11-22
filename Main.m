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
Stoff1 = washerstandoff;
Stoff2 = washerstandoff;
Wash = washerstandoff;
N1 = Fastener;
N2 = Fastener;

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
    [SupSFArr,AntSFArr,PosSFArr,InfSFArr,T1SFArr,T2SFArr,VtSFArr,VcSFArr, BLSPSFArr, BLSASFArr, BLIASFArr, BLIPSFArr, BNSPSFArr, BNSASFArr, BNIASFArr, BNIPSFArr] = GaitLoop(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass);
    
    %assume SF satisfied, then check. If SF not satsified, then toggle to 0
    safetyfactorsatisfied = 1;
    
    %% Superior Link Parametrization
    disp("Optimizing Superior Link.");
    %Flag if superior link is satisfied WRT Safety Factor Range.
    SuperiorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinSup, SupIndex] = min(SupSFArr);
    while(SuperiorSatisfied == 0)
        if(MinSup > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            if(S.T > 0.0039)
                S.T = 0.9*S.T;
            else
                S.B2 = 0.9*S.B2;
            end
            %recalculate inertial properties
%             S = calculate_inertial_props(S);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27);
            MinSup = SF.SF_sup;
        elseif(MinSup < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            S.B2 = 1.2*S.B2;
            %recalculate inertial properties
%             S = calculate_inertial_props(S);
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
        if(MinInf > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            %decrease thickness of link.
            if(In.T > 0.0039)
                In.T = 0.9*In.T;
            else
                In.B2 = 0.9*In.B2;
            end
            %recalculate inertial properties
%             In = calculate_inertial_props(In);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, InfIndex+27);
            MinInf = SF.SF_inf;
        elseif(MinInf < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            In.B2 = 1.2*In.B2;
            %recalculate inertial properties
%             In = calculate_inertial_props(In);
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
        if(MinAnt > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease width of link.
            A.B = 0.75*A.B;
            %recalculate inertial properties
%             A = calculate_inertial_props(A);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, AntIndex+27);
            MinAnt = SF.SF_ant;
        elseif(MinAnt < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase width of link.
            A.B = 1.5*A.B;
            %recalculate inertial properties
%             A = calculate_inertial_props(A);
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
        if(MinPos > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease width of link.
            P.B = 0.75*P.B;
            %recalculate inertial properties
%             P = calculate_inertial_props(P);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, PosIndex+27);
            MinPos = SF.SF_pos;
        elseif(MinPos < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase width of link.
            P.B = 1.5*P.B;
            %recalculate inertial properties
%             P = calculate_inertial_props(P);
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
        if(MinVT > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            VT.W = 0.85*VT.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VTIndex+27);
            MinVT = SF.SF_VT;
        elseif(MinVT < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            VT.W = 1.15*VT.W;
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
        if(MinVC > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrease thickness of link.
            VC.W = 0.85*VC.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VCIndex+27);
            MinVC = SF.SF_VC;
        elseif(MinVC < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increase thickness of link.
            VC.W = 1.15*VC.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VCIndex+27);
            MinVC = SF.SF_VC;
        else
            %Inferior Min SF is satisfied.
            VCsatisfied = 1;
        end
    end
          
    %% TS1 Parametrization
    disp("Optimizing Torsional Spring 1.");
    %Flag if calf velcro is satisfied WRT Safety Factor Range.
    T1satisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinT1, T1Index] = min(T1SFArr);
    while(T1satisfied == 0)
        if(MinT1 > 4)
            %Design Constraint
            if(T1.Nb < 2)
                break;
            end
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrement Nb if possible.
            T1.Nb = T1.Nb - 1;
            %update Spring
            T1 = updateSpring(T1);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T1Index+27);
            MinT1 = SF.SF_TS1;
        elseif(MinT1 < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increment Nb.
            T1.Nb = T1.Nb + 1;
            %update Spring
            T1 = updateSpring(T1);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T1Index+27);
            MinT1 = SF.SF_TS1;
        else
            %Inferior Min SF is satisfied.
            T1satisfied = 1;
        end
    end
    

    %% TS2 Parametrization
    disp("Optimizing Torsional Spring 2.");
    %Flag if calf velcro is satisfied WRT Safety Factor Range.
    T2satisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinT2, T2Index] = min(T2SFArr);
    while(T2satisfied == 0)
        if(MinT2 > 4)
            %Design Constraint
            if(T2.Nb < 2)
                break;
            end
            %Flag to recheck with entire gait cycle after has been optimized. 
            safetyfactorsatisfied = 0;
            %decrement Nb if possible.
            T2.Nb = T2.Nb - 1;
            %update Spring
            T2 = updateSpring(T2);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T2Index+27);
            MinT2 = SF.SF_TS2;
        elseif(MinT2 < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
            safetyfactorsatisfied = 0;
            %increment Nb.
            T2.Nb = T2.Nb + 1;
            %update Spring
            T2 = updateSpring(T2);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T2Index+27);
            MinT2 = SF.SF_TS2;
        else
            %Inferior Min SF is satisfied.
            T2satisfied = 1;
        end
    end
    
   %% Obtain Bolt and Bearing SF
   MinBoltIA = min(BLIASFArr);
   MinBoltIP = min(BLIPSFArr);
   MinBoltSP = min(BLSPSFArr);
   MinBoltSA = min(BLSASFArr);
   MinBrngSP = min(BNSPSFArr);
   MinBrngSA = min(BNSASFArr);
   MinBrngIA = min(BNIASFArr);
   MinBrngIP = min(BNIPSFArr);
   
end

%Output final safety factors to log file here...

%%
%Output solidworks dimensions 

%Anterior link
A.springarmholepos = 0.5*S.L;
A.outputDimensions(A);

%Posterior Link
P.springarmholepos = 0.5*In.L;
P.outputDimensions(P);

%Superior Link
S.springarmholepos = 0.4*S.L;
S.H_holes = 0.5*(S.B1-S.L);
S.outputDimensions(S);

%Inferior Link
In.springarmholepos = 0.4*In.L;
In.H_holes = 0.5*(In.B1-In.L);
In.outputDimensions(In);

%Springs
T1.L_arm=S.springarmholepos-0.5*T1.loop_diam*cosd(45);
T1.height=T1.d*T1.Nb*1.1; %maybe come back and change this
T1.outputDimensions(T1,1);

T2.L_arm=In.springarmholepos-0.5*T2.loop_diam*cosd(45);
T2.height=T2.d*T2.Nb*1.1; %maybe come back and change this
T2.outputDimensions(T2,2);

%standoff and washer
Stoff1.ID=0.0032;
Stoff1.OD=0.0045;
Stoff1.H=T1.height;
Stoff1.outputDimensions(Stoff1, 1);

Stoff2.ID=0.0032;
Stoff2.OD=0.0045;
Stoff2.H=2*T1.d; %maybe come back and change this
Stoff2.outputDimensions(Stoff2, 2);

wash.ID=0.0032;
wash.OD=0.006;
wash.H=0.0006;
wash.outputDimensions(wash, 3);

%Bearing
Brng.outputDimensions(Brng);

%Nut


%Bolt

